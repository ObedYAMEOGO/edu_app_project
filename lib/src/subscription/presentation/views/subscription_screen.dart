import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:edu_app_project/core/common/widgets/gradient_background.dart';
import 'package:edu_app_project/core/common/widgets/nested_back_button.dart';
import 'package:edu_app_project/core/enums/subscription_enum.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/media_res.dart';
import 'package:edu_app_project/src/subscription/presentation/widgets/plan_card.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  static const routeName = '/pricing';

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool showingLoader = false;
  final String organizationId = "10398376";
  final String projectId = "59159";
  final String apiKey = "0YdE9HCh9f89tiofsWTvUgI0AMOSSfEp";

  
  Future<void> saveSubscription(String referenceId, int subscriptionCode) async {
  try {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    User? user = auth.currentUser;
    if (user == null) {
      throw Exception("No user is logged in.");
    }

    Timestamp createdAt = Timestamp.now();

    // Determine expiration period based on subscription code
    int months = 1; // Default to 1 month
    if (subscriptionCode == 3) {
      months = 3;
    } else if (subscriptionCode == 12) {
      months = 12;
    }

    Timestamp expiredAt = Timestamp.fromMillisecondsSinceEpoch(
      createdAt.millisecondsSinceEpoch + (months * 30 * 24 * 60 * 60 * 1000),
    );

    await firestore.collection("subscriptions").add({
      "email": user.email,
      "referenceId": referenceId,
      "paymentStatus": "pending",
      "isCurrentSubscription": false,
      "createdAt": createdAt,
      "expiredAt": expiredAt,
    });

    print("Subscription saved successfully!");
  } catch (e) {
    print("Error saving subscription: $e");
  }
}




  String generateUniqueReference() {
    final random = Random();
    return "REF-${DateTime.now().millisecondsSinceEpoch}-${random.nextInt(100000)}";
  }

  Future<void> initiatePayment({
    required String title,
    required double price,
    required String pictureUrl,
    required String description,
    required int subscriptionCode,
    required BuildContext context,
  }) async {
    const String url =
        "https://api.yengapay.com/api/v1/groups/{organization_id}/payment-intent/{project_id}";

     // Générer une seule référence unique
    String referenceId = generateUniqueReference();


    final Map<String, dynamic> payload = {
      "paymentAmount": price,
      "reference": referenceId,
      "articles": [
        {
          "title": title,
          "description": description,
          "pictures": [pictureUrl],
          "price": price,
        },
      ],
    };

    try {
      final response = await http.post(
        Uri.parse(
          url
              .replaceFirst("{organization_id}", organizationId)
              .replaceFirst("{project_id}", projectId),
        ),
        headers: {
          "Content-Type": "application/json",
          "x-api-key": apiKey,
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final checkoutUrl = data["checkoutPageUrlWithPaymentToken"];
        print("Payment URL: $checkoutUrl");

      // Enregistrer la souscription avant d'envoyer la requête de paiement
      await saveSubscription(referenceId, subscriptionCode);

        // Naviguer vers l'écran WebView
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => WebViewScreen(url: checkoutUrl),
          ),
        );
      } else {
        print("Erreur: ${response.statusCode}");
        //print(url);
        //print(payload.toString());
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text('Tarifs',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17,
                color: Colours.darkColour)),
        leading: const NestedBackButton(),
      ),
      body: GradientBackground(
        image: Res.documentsGradientBackground,
        child: SafeArea(
          child: Center(
            child: ListView.builder(
              itemCount: Subscription.values.length,
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemBuilder: (BuildContext context, int index) {
                final subscription = Subscription.values[index];
                return PlanCard(
                  subscription: subscription, 
                  onPressed: ()=> initiatePayment(
                    title: subscription.title, 
                    price: subscription.price, 
                    description: subscription.code.toString(),
                    pictureUrl: 'https://icons.veryicon.com/png/o/internet--web/online-finance/transaction.png', 
                    subscriptionCode: subscription.code,
                    context: context
                    )
                  );
              },
            ),
          ),
        ),
      ),
    );
  }
}




class WebViewScreen extends StatefulWidget {
  final String url;

  WebViewScreen({required this.url});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true; // Indicateur de chargement

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setNavigationDelegate(
    NavigationDelegate(
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith("https://unilink-sever.vercel.app/")) {
          print("Opening in external browser: ${request.url}");
          launchUrl(Uri.parse(request.url), mode: LaunchMode.externalApplication);
          return NavigationDecision.prevent; // Prevent WebView from loading
        }
        return NavigationDecision.navigate;
      },
      onPageStarted: (String url) {
        setState(() {
          _isLoading = true;
        });
        print("Page started loading: $url");
      },
      onPageFinished: (String url) {
        setState(() {
          _isLoading = false;
        });
        print("Page finished loading: $url");
      },
      onWebResourceError: (WebResourceError error) {
        print("WebResourceError: ${error.description}");
      },
    ),
  )
  ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Abonnement", style: TextStyle(fontSize: 17),)),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}


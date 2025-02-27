// ignore_for_file: constant_identifier_names

enum Subscription {
  MONTHLY(
    code: 1,
    title: 'Pack Mensuel',
    description: 'Un mois d’accès illimité au contenu',
    price: 2000,
    star: 1,
  ),
  QUARTERLY(
    code: 3,
    title: 'Pack Trimestriel',
    description: 'Trois mois d’apprentissage continu.',
    price: 5000,
    star: 2,
  ),
  ANNUALLY(
    code: 12,
    title: 'Pack Annuel',
    description: 'Un an d’accès complet au contenu exclusif.',
    price: 15000,
    star: 3,
  );

  // Déclaration correcte d'un constructeur pour une énumération
  const Subscription({
    required this.code,
    required this.title,
    required this.description,
    required this.price,
    required this.star,
  });

  final int code;
  final String title;
  final String description;
  final double price;
  final int star;

  // Ajout d'une méthode pour récupérer une Subscription à partir de son code
  static Subscription? fromCode(int code) {
    return Subscription.values.firstWhere(
      (sub) => sub.code == code,
      // ignore: cast_from_null_always_fails
      orElse: () => null as Subscription,
    );
  }
}

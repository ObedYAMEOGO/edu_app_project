class PaywallConfig {
  const PaywallConfig._();
  static const entitlementId = 'pro';

  static const monthlyId = 'test_beta_999_1m_999';
  static const yearlyId = 'test_beta_100_1y_100';

  static const footerText = 'You can cancel your subscription anytime.';

  static const appleApiKey = 'apple_api_key';
  static const googleApiKey = 'google_api_key';
}

/*
it's easier to use revenue cat because they automatically validate the purchase
in their backend, so we don't have to write our own backend to validate the
purchases. It also handles the native APIs for us, and we have one dashboard
to manage our purchases from one place


1. Go to play store, set up a release track
(This could be testing or production), and then go to app signing and
copy the key.

2. Go to AndroidManifest.xml and add the following:
<uses-permission android:name="com.android.vending.BILLING" />

3. Set up the billing profile in your play console >> setup >> payments
profile...

4. Go to your app on the play console and set up the offerings. In our case,
Monthly and Yearly.

5. Go to the play console and create a service account. This will be used to set
up the backend for validating the purchases.

*/

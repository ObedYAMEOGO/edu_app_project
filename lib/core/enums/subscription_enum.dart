// ignore_for_file: constant_identifier_names

enum Subscription {
  MONTHLY(
    code: 1,
    title: 'Mensuel',
    description: 'Un mois d’accès illimité au contenu premium.',
    price: 5994, // 9.99 USD * 600
  ),
  QUARTERLY(
    code: 3,
    title: 'Trimestriel',
    description: 'Trois mois d’apprentissage continu.',
    price: 14994, // 24.99 USD * 600
  ),
  ANNUALLY(
    code: 12,
    title: 'Annuel',
    description: 'Un an d’accès complet au contenu exclusif.',
    price: 53994, // 89.99 USD * 600
  );

  const Subscription({
    required this.code,
    required this.title,
    required this.description,
    required this.price,
  });

  final int code;
  final String title;
  final String description;
  final double price;
}

// ignore_for_file: constant_identifier_names

enum Subscription {
  MONTHLY(
    code: 1,
    title: 'Pack Mensuel',
    description: 'Un mois d’accès illimité au contenu premium.',
    price: 1499, // 9.99 USD * 600
  ),
  QUARTERLY(
    code: 3,
    title: 'Pack Trimestriel',
    description: 'Trois mois d’apprentissage continu.',
    price: 3999, // 24.99 USD * 600
  ),
  ANNUALLY(
    code: 12,
    title: 'Pack Annuel',
    description: 'Un an d’accès complet au contenu exclusif.',
    price: 6999, // 89.99 USD * 600
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

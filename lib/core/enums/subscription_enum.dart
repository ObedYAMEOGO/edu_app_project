// ignore_for_file: constant_identifier_names

enum Subscription {
  MONTHLY(
    code: 1,
    title: 'Mensuel',
    description: 'Un mois d\’accès illimité au contenu premium.',
    price: 5994, 
  ),
  QUARTERLY(
    code: 3,
    title: 'Trimestriel',
    description: 'Trois mois d\’apprentissage continu.',
    price: 14994, 
  ),
  ANNUALLY(
    code: 12,
    title: 'Annuel',
    description: 'Un an d\’accès complet au contenu exclusif.',
    price: 53994, 
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

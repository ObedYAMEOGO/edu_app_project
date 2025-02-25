// ignore_for_file: constant_identifier_names

enum Subscription {
  MONTHLY(
    code: 1,
<<<<<<< HEAD
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
=======
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
>>>>>>> 6eb62c92b1ea985dfb2afe19d9909b07e7290841
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

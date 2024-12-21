import 'package:edu_app_project/core/res/media_res.dart';
import 'package:equatable/equatable.dart';

class PageContent extends Equatable {
  const PageContent(
      {required this.image, required this.title, required this.description});
  final String title;
  final String description;
  final String image;

  const PageContent.first()
      : this(
            image: Res.pageContentFirst,
            title: "Apprentissage Simplifié",
            description:
                "Accédez à des formations de qualité pour booster vos compétences professionnelles et personnelles.");

  const PageContent.second()
      : this(
            image: Res.pageContentSecond,
            title: "Une large Communauté",
            description:
                "Échangez avec d'autres apprenants et experts qui partagent vos centres d'interêts");

  const PageContent.third()
      : this(
            image: Res.pageContentThird,
            title: "Opportunités de Bourses",
            description:
                "Découvrez des offres de bourses d'études et de financement pour soutenir votre parcours éducatif.");

  @override
  List<String> get props => [title, description];
}

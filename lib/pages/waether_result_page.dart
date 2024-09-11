import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Importez ce package pour afficher les SVG dans Flutter
import 'package:intl/intl.dart';
import 'package:waestro_mobile/models/weather_model.dart'; // Assurez-vous que vous avez bien ce modèle
import 'package:waestro_mobile/styles/app_styles.dart'; // Import de AppStyle

class WeatherResultPage extends StatelessWidget {
  final Weather weather;

  WeatherResultPage({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor, // Utilisation de la couleur de fond
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Rendre l'appbar transparent
        iconTheme: IconThemeData(color: AppStyle.primaryTextColor), // Couleur de l'icône
      ),
      body: Column(
        children: <Widget>[
          // Utilisation d'un Container avec une hauteur de 45% de la hauteur totale de l'écran
          Container(
            height: MediaQuery.of(context).size.height * 0.40,
            child: Padding(
              padding: const EdgeInsets.all(42.0),
              child: Row(
                children: [
                  // Colonne pour la ville, la date et la température ressentie
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Titre principal - Ville
                      Text(
                        weather.cityName,
                        style: AppStyle.cityNameStyle, // Style pour le nom de la ville
                      ),
                      SizedBox(height: 10),

                      // Date d'aujourd'hui
                      Text(
                        DateFormat('dd MMMM, EEEE').format(DateTime.now()), // Date formatée
                        style: AppStyle.dateStyle, // Style pour la date
                      ),
                      SizedBox(height: 10),

                      // Température ressentie
                      Text(
                        'Real feel ${weather.feelslike}°',
                        style: AppStyle.realFeelStyle, // Style pour le ressenti
                      ),
                    ],
                  ),

                  Spacer(), // Espace flexible pour pousser la température à droite

                  // Température principale à droite
                  Text(
                    '${weather.temp}°',
                    style: AppStyle.tempStyle, // Style pour la température
                  ),
                ],
              ),
            ),
          ),

          // Prévisions du jour et des jours suivants avec un fond en dégradé
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(-1, 1),
                  colors: <Color>[
                    Color(0xFF101010), // Couleur de début
                    Color.fromARGB(255, 38, 40, 55), // Couleur de fin
                  ],
                  tileMode: TileMode.mirror, // Mode de tuile
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 42.0, top: 15.0, right: 42.0),
                child: ListView.builder(
                  itemCount: weather.days.length,
                  itemBuilder: (context, index) {
                    final day = weather.days[index];
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                          title: Text(
                            '${DateFormat('dd MMMM').format(day.date)}', // Formatage de la date
                            style: AppStyle.dayTitleStyle, // Style pour le titre du jour
                          ),
                          subtitle: Row(
                            children: [
                              // Température max et min
                              Text(
                                'Max: ${day.maxTemp}°C - Min: ${day.minTemp}°C',
                                style: AppStyle.daySubtitleStyle, // Style pour le sous-titre
                              ),
                              SizedBox(width: 8), // Espacement entre la température et la phase lunaire
                              
                              // Phase lunaire
                              SvgPicture.asset(
                                day.getMoonPhaseImagePath(),
                                width: 24, // Largeur de l'image de la phase lunaire
                                height: 24, // Hauteur de l'image de la phase lunaire
                              ),
                            ],
                          ),
                          trailing: Text(
                            day.condition, // Condition météo
                            style: AppStyle.conditionStyle, // Style pour la condition météo
                          ),
                        ),
                        Divider(color: AppStyle.dividerColor), // Ligne de séparation
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tp3/boxes.dart';
import 'package:tp3/model/job.dart';
import 'package:tp3/widget/delete_dialog.dart';
import 'package:tp3/widget/proposition_dialog.dart';

class PropositionPage extends StatefulWidget {
  const PropositionPage({Key? key}) : super(key: key);

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<PropositionPage> {
  @override
  void dispose() {
    Hive.close();

    super.dispose();
  }

  //Page d'accueil
  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          title: const Text('Offres d\'emploi'),
          centerTitle: true, //titre centré
        ),
        body: ValueListenableBuilder<Box<Proposition>>(
          valueListenable: Boxes.getProposition().listenable(),
          builder: (context, box, _) {
            final transactions = box.values.toList().cast<Proposition>();

            return buildContent(transactions);
          },
        ),
        //Ajout de texte pour le bouton "Ajouter"
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add),
          label: Text("Ajouter une proposition"),
          onPressed: () =>
              showDialog(
                context: context,
                builder: (context) =>
                    PropositionDialog(
                      onClickedDone: addProposition,
                    ),
              ),
        ),
      );

  //Si aucune offre est présente, alors un texte s'affiche
  Widget buildContent(List<Proposition> propositions) {
    if (propositions.isEmpty) {
      return const Center(
        child: Text(
          'Pas d\'offre pour l\'instant',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      return Column(
        children: [
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: propositions.length,
              itemBuilder: (BuildContext context, int index) {
                final transaction = propositions[index];

                return buildProposition(context, transaction);
              },
            ),
          ),
        ],
      );
    }
  }

  Widget buildProposition(BuildContext context, Proposition proposition,) {
  //affichage des propositions créées
    return Card(

      color: Colors.white,

      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        title: Text(
          proposition.entreprise,
          maxLines: 2,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          proposition.monSentiment.toString(),
        ),
        trailing: Text(proposition.salaireNet.toString() + " EUR"),
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Salaire brut : " +
                              proposition.salaireBrut.toString() + " EUR",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Salaire Net : " + proposition.salaireNet.toString() +
                              " EUR",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Statut : " + proposition.statutPropose.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          //espace entre les boutons et le texte
          Padding(
            padding: const EdgeInsets.all(10.0),
          ),
          buildButtons(context, proposition),

        ],

      ),


    );
  }

  Widget buildButtons(BuildContext context, Proposition proposition) =>
      Row(
        children: [
          Expanded(
            child: TextButton.icon(
              label: const Text('Editer'),
              icon: const Icon(Icons.edit),
              style: TextButton.styleFrom(backgroundColor: Colors.lightGreenAccent, primary: Colors.black),
              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          PropositionDialog(
                            proposition: proposition,
                            onClickedDone: (entreprise, salaireBrut, salaireNet,
                                statutPropose, monSentiment) =>
                                editProposition(
                                    proposition, entreprise, salaireBrut,
                                    salaireNet, statutPropose, monSentiment),
                          ),
                    ),
                  ),
            ),
          ),
          Spacer(flex:2),
          Expanded(
            child: TextButton.icon(
              label: const Text('Supprimer'),
              icon: const Icon(Icons.delete),
              style: TextButton.styleFrom(backgroundColor: Colors.redAccent, primary: Colors.black),

              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          DeleteDialog(
                              proposition: proposition,
                              onClickedDelete: () =>
                                  deleteProposition(proposition)),
                    ),
                  ),
            ),
          )
        ],
      );

  Future addProposition(String entreprise, double salaireBrut,
      double salaireNet, String statutPropose, String monSentiment,) async {
    final proposition = Proposition()
      ..entreprise = entreprise
      ..salaireBrut = salaireBrut
      ..salaireNet = salaireNet
      ..statutPropose = statutPropose
      ..monSentiment = monSentiment;

    final box = Boxes.getProposition();
    box.add(proposition);
  }

  //fonction pour sauvegarder une carte modifiée
  void editProposition(Proposition proposition, String entreprise,
      double salaireBrut, double salaireNet, String statutPropose,
      String monSentiment,) {
    proposition.entreprise = entreprise;
    proposition.salaireBrut = salaireBrut;
    proposition.salaireNet = salaireNet;
    proposition.statutPropose = statutPropose;
    proposition.monSentiment = monSentiment;

    proposition.save();
  }

  //fonction pour supprimer une carte créée
  void deleteProposition(Proposition proposition) {

    proposition.delete();
  }


}

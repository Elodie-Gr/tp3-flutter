import 'package:flutter/material.dart';
import 'dart:math';
import '../model/job.dart';

class PropositionDialog extends StatefulWidget {
  final Proposition? proposition;
  final Function(String name, double brut, double net, String statut, String comment) onClickedDone;

  const PropositionDialog({
    Key? key,
    this.proposition,
    required this.onClickedDone,
  }) : super(key: key);

  @override
  _PropositionDialogState createState() => _PropositionDialogState();
}

class _PropositionDialogState extends State<PropositionDialog> {
  final formKey = GlobalKey<FormState>();
  final entrepriseController = TextEditingController();
  final salaireBrutController = TextEditingController();
  final salaireNetController = TextEditingController();
  final monSentimentController = TextEditingController();

  final items = ['Salarié non-cadre 22%', 'Salarié cadre 25%', 'Fonction publique 15%', 'Profession libérale 45%', 'Portage salarial 51%'];
  final pourcentages = [0.78, 0.75, 0.85, 0.55, 0.49];

  String? dropdownValue = 'Salarié non-cadre 22%';
  int dropdownIndex = 0;

  double roundDouble(double value, int places){
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  //calcul du salaire
  double calculSalaire(double salaire, bool isBrut, double pourcentage){

    if(!isBrut) {
      pourcentage += 1;
    }

    return roundDouble(salaire * pourcentage, 2);

  }


  onBrutChange(){
    setState(() {
      double? brut = double.tryParse(salaireBrutController.text);
      double net = 0;
      if(brut != null){
        net = calculSalaire(brut, true, pourcentages[dropdownIndex]);
      }

      if(net >= 0) {
        salaireNetController.text = net.toString();
      }
    });
  }

  onNetChange(){
    setState(() {
      double? net = double.tryParse(salaireNetController.text);
      double brut = 0;
      if(net != null){
        brut = calculSalaire(net, false, pourcentages[dropdownIndex]);
      }
      if(brut >= 0) {
        salaireBrutController.text = brut.toString();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.proposition != null) {
      final proposition = widget.proposition!;

      entrepriseController.text = proposition.entreprise;
      salaireBrutController.text = proposition.salaireBrut.toString();
      salaireNetController.text = proposition.salaireNet.toString();
      monSentimentController.text = proposition.monSentiment;

      dropdownValue = proposition.statutPropose;
      dropdownIndex = items.indexOf(dropdownValue!);

    }
  }

  @override
  void dispose() {

    entrepriseController.dispose();
    salaireBrutController.dispose();
    salaireNetController.dispose();
    monSentimentController.dispose();

    super.dispose();
  }

  //formulaire d'ajout d'une proposition
  @override
  Widget build(BuildContext context) {
    final isEditing = widget.proposition != null;
    final title = isEditing ? 'Editer une offre' : 'Ajouter une offre';

    return AlertDialog(

      title: Text(title),

      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          //modifier taille de la boîte de dialogue
          child: Container(
            width: 600,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 8),
              buildName(),
              const SizedBox(height: 8),
              buildBrut(),
              const SizedBox(height: 8),
              buildNet(),
              const SizedBox(height: 8),
              buildStatut(),
              const SizedBox(height: 8),
              buildComment(),
            ],
          ),
        ),
        ),
      ),
      actions: <Widget>[
        buildCancelButton(context),
        buildAddButton(context, isEditing: isEditing),
      ],
    );
  }

  Widget buildName() => TextFormField(
        controller: entrepriseController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          icon: Icon(Icons.business),
          labelText: 'Nom de l\'entreprise',
        ),
        maxLines: 2,
        validator: (name) =>
            name != null && name.isEmpty ? 'Saisir un nom' : null,
      );

  Widget buildBrut() => TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
            icon: Icon(Icons.euro),
            labelText: 'Mensuel Brut',
            suffixText: "EUR"
        ),
        keyboardType: TextInputType.number,
        validator: (amount) => amount != null && double.tryParse(amount) == null
            ? 'Saisir un nombre valide'
            : null,
        onChanged: (text){
          onBrutChange();
        },
        controller: salaireBrutController,
      );

  Widget buildNet() => TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          icon: Icon(Icons.euro),
          labelText: 'Mensuel Net',
          suffixText: "EUR"
        ),
        keyboardType: TextInputType.number,
        validator: (amount) => amount != null && double.tryParse(amount) == null
            ? 'Saisir un nombre valide'
            : null,
        onChanged: (text){
          onNetChange();
        },
        controller: salaireNetController,

      );


  DropdownMenuItem<String> builMenuItem(String item) => DropdownMenuItem(
    value: item,
    child: Text(
      item,
    ),
  );

  Widget buildStatut() => DropdownButtonFormField<String>(
    decoration: const InputDecoration(
      border: OutlineInputBorder(),
      icon: Icon(Icons.account_circle),
      labelText: 'Statut',
    ),
    value: dropdownValue,
    items: items.map(builMenuItem).toList(),
    onChanged: (value) => setState(() {
      if(value != null){
        dropdownValue = value;
        dropdownIndex = items.indexOf(value);
      }
      onBrutChange();
    }),
    validator: (name) => name != null && name.isEmpty ? 'Statut' : null,
  );

  Widget buildComment() => TextFormField(
    controller: monSentimentController,
    decoration: const InputDecoration(
      border: OutlineInputBorder(),
      icon: Icon(Icons.rate_review),
      labelText: 'Commentaire',
    ),
    maxLines: 5,
    keyboardType: TextInputType.multiline,
    validator: (name) =>
    name != null && name.isEmpty ? 'Saisir son sentiment' : null,
  );

  //annuler la création d'une proposition
  Widget buildCancelButton(BuildContext context) => TextButton.icon(
        label: const Text('Annuler'),
        icon: const Icon(Icons.cancel),
        style: TextButton.styleFrom(backgroundColor: Colors.red, primary: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      );

  Widget buildAddButton(BuildContext context, {required bool isEditing}) {
//valider la création d'une proposition
    return TextButton.icon(
      label: const Text("Ajouter"),
      icon: const Icon(Icons.add_circle),
      style: TextButton.styleFrom(backgroundColor: Colors.lightGreen, primary: Colors.black),
      onPressed: () async {
        final isValid = formKey.currentState!.validate();

        if (isValid) {
          final entreprise = entrepriseController.text.substring(0, 1).toUpperCase() + entrepriseController.text.substring(1, entrepriseController.text.length);
          final salaireBrut = double.tryParse(salaireBrutController.text) ?? 0;
          final salaireNet = double.tryParse(salaireNetController.text) ?? 0;
          final statutPropose = dropdownValue!;
          final monSentiment = monSentimentController.text;


          widget.onClickedDone(entreprise, salaireBrut, salaireNet, statutPropose, monSentiment);

          Navigator.of(context).pop();
          //Ajout d'une snackbar pour prévenir l'utilisateur de la suppression
          const snackBar = SnackBar (
            content : Text ( 'Proposition ajoutée/modifiée !' ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
    );
  }
}

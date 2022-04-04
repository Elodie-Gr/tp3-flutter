import 'package:flutter/material.dart';
import 'dart:math';
import '../model/job.dart';

class DeleteDialog extends StatefulWidget {
  final Proposition? proposition;
  final Function() onClickedDelete;

  const DeleteDialog({
    Key? key,
    this.proposition,
    required this.onClickedDelete,
  }) : super(key: key);

  @override
  _DeleteDialogState createState() => _DeleteDialogState();
}

const title = "Supprimer";

class _DeleteDialogState extends State<DeleteDialog> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {

  }

  //boite de dialogue qui s'affiche quand on appuie sur le bouton "supprimer"
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text("Etes-vous sûr de vouloir supprimer ?"),
      actions: [
        buildCancelButton(context),
        buildDeleteButton(context),
      ],
    );
  }

  Widget buildCancelButton(BuildContext context) => TextButton.icon(
    label: const Text('Annuler'),
    icon: const Icon(Icons.cancel_outlined),
    style: TextButton.styleFrom(backgroundColor: Colors.orangeAccent, primary: Colors.black),
    onPressed: () => Navigator.of(context).pop(),
  );

  Widget buildDeleteButton(BuildContext context) {
    return TextButton.icon(
        label: const Text('Supprimer'),
        icon: const Icon(Icons.delete),
        style: TextButton.styleFrom(backgroundColor: Colors.red, primary: Colors.black),
        onPressed: () async {
          widget.onClickedDelete();
          Navigator.of(context).pop();
          //Ajout d'une snackbar pour prévenir l'utilisateur de la suppression
          const snackBar = SnackBar (
            content : Text ( 'Proposition supprimée !' ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
    );
  }

}
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ProduitBox extends StatelessWidget {
  final String nomProduit;
  final bool selProduit;
  final String photo;
  final Function(bool?)? onChanged;
  final Function()? onTap;
  final Function(BuildContext)? delProduit;

  const ProduitBox({
    super.key,
    required this.nomProduit,
    required this.photo,
    this.selProduit = false,
    this.onChanged,
    this.delProduit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => delProduit?.call(context),
              icon: Icons.delete,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(45),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(45),
            ),
            height: 120,
            child: Row(
              children: [
                Checkbox(value: selProduit, onChanged: onChanged),
                Image.asset(
                  photo,
                  width: 50,
                  height: 50,
                ),
                const SizedBox(width: 10),
                Text(
                  nomProduit,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

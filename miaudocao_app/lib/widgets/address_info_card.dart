import 'package:flutter/material.dart';

class AddressInfoCard extends StatelessWidget {
  final String endereco;
  final Function() onTap;

  AddressInfoCard({
    @required this.endereco,
    @required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade200,
        boxShadow: kElevationToShadow[4],     
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              'Localização',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
            Divider(
              thickness: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text(endereco)),
                SizedBox(width: 8),
                Icon(Icons.pin_drop)
              ],
            ),
            SizedBox(height: 5),
            InkWell(
              onTap: onTap,
              child: Text(
                'Ver no mapa',
                style: TextStyle(
                  color: Theme.of(context).primaryColor
                ),
              ),
            ),
          ]
        )
      )
    );
  }
}
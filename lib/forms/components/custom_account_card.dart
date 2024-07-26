import 'package:f_managment_stream_accounts/models/account.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ImprovedCard extends StatelessWidget {
  Account? account;
  Function? deleteAccount;
  bool disableColorDelete;
  int? quantityInSubscription;
  ImprovedCard(
      {Key? key, this.account, this.deleteAccount, this.quantityInSubscription, this.disableColorDelete = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade900, Colors.blue.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {}, // Add functionality on tap
                splashColor: Colors.white.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(constraints),
                      const SizedBox(height: 20),
                      _buildContent(constraints),
                      const SizedBox(height: 20),
                      _buildFooter(constraints),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            account!.email!,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              fontSize: constraints.maxWidth > 600 ? 24 : 20,
              color: Colors.white,
            ),
          ),
        ),
        IconButton(
          //disabledColor: disableColorDelete ? Colors.grey : Colors.amber,
          icon: Icon(Icons.delete, color:  disableColorDelete ? Colors.grey : Colors.red),
          onPressed: () {
            if (deleteAccount != null) {
              deleteAccount!();
            }
          },
        ),
      ],
    );
  }

  Widget _buildContent(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.movie, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              account!.platform!.namePlatform!,
              style: TextStyle(
                color: Colors.white,
                fontSize: constraints.maxWidth > 600 ? 20 : 15,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            account!.typeAccount!.nameTypeAccount!,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.event_seat_outlined),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  '${account!.perfilQuantity}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            /* const Text(
              ' 5',
              style: TextStyle(color: Colors.white70),
            ), */
          ],
        ),
        Text(
          '\$${account!.price}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: constraints.maxWidth > 600 ? 36 : 30,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

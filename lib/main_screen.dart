import 'package:flutter/material.dart';
import 'package:flutter_anim/models/transaction.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

import 'models/credit_card.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  List<CreditCard> listCreditCards;

  AnimationController animationController;
  SequenceAnimation sequenceAnimation;

  bool detailsOpen = false;

  @override
  void initState() {
    addCreditCards();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    sequenceAnimation = new SequenceAnimationBuilder()
        .addAnimatable(
            animatable: Tween<double>(begin: 1, end: 0),
            from: Duration(milliseconds: 0),
            to: Duration(milliseconds: 1000),
            tag: 'card-padding')
        .addAnimatable(
            animatable: Tween<double>(begin: 100, end: 50),
            from: Duration(milliseconds: 500),
            to: Duration(milliseconds: 1000),
            tag: 'transactions-padding')
        .addAnimatable(
            animatable: Tween<double>(begin: 0, end: 1),
            from: Duration(milliseconds: 500),
            to: Duration(milliseconds: 1000),
            tag: 'transactions-opacity')
        .addAnimatable(
            animatable: Tween<double>(begin: 1, end: 0),
            from: Duration(milliseconds: 500),
            to: Duration(milliseconds: 1000),
            tag: 'wallet-opacity')
        .addAnimatable(
            animatable: Tween<double>(begin: 0, end: 1),
            from: Duration(milliseconds: 1000),
            to: Duration(milliseconds: 1500),
            tag: 'details-opacity')
        .animate(animationController);

    super.initState();
  }

  void addCreditCards() {
    listCreditCards = new List<CreditCard>();

    var myCreditCard = CreditCard(
        [Colors.pink[200], Colors.pink[500], Colors.pink[400]],
        "MasterCard",
        "Salvador Valverde",
        "**** **** **** 1234",
        "11/24");
    myCreditCard.addTransaction(Transaction("Food", "11/20", 22));
    myCreditCard.addTransaction(Transaction("Amazon", "07/20", 80));
    myCreditCard.addTransaction(Transaction("Shopping", "03/20", 30));
    myCreditCard.addTransaction(Transaction("Internet", "08/20", 45));

    listCreditCards.add(myCreditCard);

    var creditCardTwo = CreditCard(
        [Colors.blue[300], Colors.blue[700], Colors.blue[500]],
        "MasterCard",
        "David Foster",
        "**** **** **** 4323",
        "06/22");
    creditCardTwo.addTransaction(Transaction("Ebay", "11/20", 100));
    creditCardTwo.addTransaction(Transaction("Games", "07/20", 60));
    creditCardTwo.addTransaction(Transaction("Phone", "03/20", 20));
    creditCardTwo.addTransaction(Transaction("Home", "08/20", 800));

    listCreditCards.add(creditCardTwo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Stack(
            children: [
              PageView.builder(
                  itemCount: listCreditCards.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                            60 * sequenceAnimation['card-padding'].value,
                            150 * sequenceAnimation['card-padding'].value,
                            60 * sequenceAnimation['card-padding'].value,
                            600 * sequenceAnimation['card-padding'].value,
                          ),
                          decoration: BoxDecoration(
                              color: listCreditCards[index].colors[2],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 150, 30, 0),
                          child: Column(
                            children: [
                              creditCardWidget(listCreditCards[index]),
                              Opacity(
                                opacity:
                                    sequenceAnimation['transactions-opacity']
                                        .value,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: sequenceAnimation[
                                                  'transactions-padding']
                                              .value),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Last Transactions",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        children: listTransactions(
                                            listCreditCards[index]),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      sequenceAnimation['wallet-opacity'].value > 0
                          ? Opacity(
                              opacity:
                                  sequenceAnimation['wallet-opacity'].value,
                              child: Text(
                                "Wallet",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : Opacity(
                              opacity:
                                  sequenceAnimation['details-opacity'].value,
                              child: Text(
                                "Details",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold),
                              )),
                      InkWell(
                        onTap: () => showAddCreditCard(context),
                        child: Container(
                          height: 50,
                          width: 50,
                          child: Icon(Icons.add),
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget creditCardWidget(CreditCard card) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            animationController.forward();
            setState(() {
              if (!detailsOpen)
                animationController.forward();
              else
                animationController.reverse();

              detailsOpen = !detailsOpen;
            });
          },
          child: Container(
            height: 150,
            width: 300,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [card.colors[0], card.colors[1]]),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 7,
                      offset: Offset(-7, 7),
                      blurRadius: 10)
                ]),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    card.bank,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(card.ccNumber,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.normal)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(card.name,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.normal)),
                      Text(card.ccDate,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.normal))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> listTransactions(CreditCard card) {
    List<Widget> transactions = new List<Widget>();

    for (Transaction transaction in card.getTransactions()) {
      transactions.add(Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.type,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  transaction.date,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
            Text(
              "\$${transaction.quantity}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ));
    }

    return transactions;
  }

  void showAddCreditCard(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: TextField(
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.black12,
                          hintText: "Credit Card",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide:
                                  BorderSide(width: 0, color: Colors.black12)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide:
                                  BorderSide(width: 0, color: Colors.black12))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.black12,
                                hintText: "CCV",
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide: BorderSide(
                                        width: 0, color: Colors.black12)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide: BorderSide(
                                        width: 0, color: Colors.black12))),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextField(
                            style: TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.black12,
                                hintText: "MM/YY",
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide: BorderSide(
                                        width: 0, color: Colors.black12)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide: BorderSide(
                                        width: 0, color: Colors.black12))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 70,
                    decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: Text("Add",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          )),
                    ),
                  )
                ],
              ),
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
        );
      },
    );
  }
}

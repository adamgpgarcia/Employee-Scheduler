import 'package:flutter/material.dart';

//this widget allows the user to filters shifts on the schedule viewer page, all, me, pickup shift
class FilterButtons extends StatefulWidget {
  int filter;
  Function setFilter;
  FilterButtons(this.filter, this.setFilter);

  @override
  _FilterButtonsState createState() => _FilterButtonsState();
}

class _FilterButtonsState extends State<FilterButtons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ButtonBar(
        buttonHeight: 30,
        buttonPadding: EdgeInsets.all(2),
        children: <Widget>[
          if (widget.filter == 0)
            RaisedButton(
              color: Colors.white,
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey[850], width: .5)),
              child: Text(
                "All",
                style: TextStyle(
                    color: Colors.teal[900], fontWeight: FontWeight.bold),
              ),
            )
          else
            RaisedButton(
              color: Colors.teal[900],
              onPressed: () {
                widget.setFilter(0);
              },
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey[850], width: .5)),
              child: Text(
                "All",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          if (widget.filter == 1)
            RaisedButton(
              color: Colors.white,
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey[850], width: .5)),
              child: Text(
                "Personal",
                style: TextStyle(
                    color: Colors.teal[900], fontWeight: FontWeight.bold),
              ),
            )
          else
            RaisedButton(
              color: Colors.teal[900],
              onPressed: () {
                widget.setFilter(1);
              },
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey[850], width: .5)),
              child: Text(
                "Personal",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          if (widget.filter == 2)
            RaisedButton(
              color: Colors.white,
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey[850], width: .5)),
              child: Text(
                "Pick up",
                style: TextStyle(
                    color: Colors.teal[900], fontWeight: FontWeight.bold),
              ),
            )
          else
            RaisedButton(
              color: Colors.teal[900],
              onPressed: () {
                widget.setFilter(2);
              },
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey[850], width: .5)),
              child: Text(
                "Pick up",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}

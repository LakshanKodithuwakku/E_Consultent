import 'package:econsultent/cells/detail_cell.dart';
import 'package:econsultent/models/consultant.dart';
import 'package:econsultent/utils/custom_icons_icons.dart';
import 'package:econsultent/utils/he_color.dart';
import 'package:flutter/material.dart';
import 'package:econsultent/pages/Booking.dart';
import 'package:econsultent/pages/Rating.dart';

class DetailPage extends StatefulWidget {
  final Consultant consultant;

  const DetailPage({Key key, @required this.consultant}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

/// ***********************************
/// Dropdown menu Constants
/// ***********************************
class Constants{
  static const String Booking = 'Booking';
  static const String Report = 'Report';
  static const String GiveReview = 'GiveReview';

  static const List<String> choices = <String>[
    Booking,
    GiveReview,
    Report
  ];
}

class _DetailPageState extends State<DetailPage> {
  /// **********************************************
  /// LIFE CYCLE METHODS
  /// **********************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleSection(),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dr.' +
                        widget.consultant.firstName +
                        ' ' +
                        widget.consultant.lastName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Icon(
                        CustomIcons.pin_location,
                        size: 14,
                        color: HexColor('#222222'),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        'Kandy, Sri Lanka',
                        style: TextStyle(
                          color: HexColor('#000000'),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: HexColor('#FFF9EA'),
                      border: Border.all(color: HexColor('#FFEDBE'), width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.consultant.type + ' Specialist',
                      style: TextStyle(
                        color: HexColor('#FFBF11'),
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Text(
                    'Dr. Albert Alexanderis a Renal Physician who has comprehensive expertise in the fields of Renal Medicine and Internal Medicine. While Dr Ho specializes in dialysis and critical care nephrology, years of extensive training have also equipped him with skills to effectively handle a wide range of other kidney diseases, including kidney impairment, inflammation, infection and transplantation.',
                    style: TextStyle(
                      color: HexColor('#2E2E2E'),
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  SizedBox(
                    height: 91,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DetailCell(title: '162', subTitle: 'Clients'),
                        DetailCell(title: '4+', subTitle: 'Exp. Years'),
                        DetailCell(title: '4273', subTitle: 'Rating'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Text(
                    'Apart from kidney-related conditions, Dr Ho also offers care and consultation in various medical conditions that are related to kidney disease, such as hypertension, diabetes and vascular diseases.',
                    style: TextStyle(
                      color: HexColor('#000000'),
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// **********************************************
  /// WIDGETS
  /// **********************************************

  /// App Bar
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: HexColor('#00C6AD'),
      elevation: 0,
      brightness: Brightness.dark,
      iconTheme: IconThemeData(color: Colors.white),

      leading: IconButton(
        icon: Icon(CustomIcons.arrow_left, size: 20),
        onPressed: () => Navigator.pop(context),
      ),

      /// ***********************************
      /// Dropdown menu
      /// ***********************************
      actions: [
        PopupMenuButton<String>(
          onSelected: choiceAction,
          itemBuilder: (BuildContext context){
            return Constants.choices.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],

    );
  }

  /// ***********************************
  /// Dropdown menu choice action
  /// ***********************************
  void choiceAction(String choice){
    if(choice == Constants.Booking){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> MyDropDown()));
    }else if(choice == Constants.Report){
       _showMultiSelect(context);
    }else if(choice == Constants.GiveReview){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> RatingsPage()));
    }
  }

  /// Title Section
  Container _titleSection() {
    return Container(
      height: 250,
      color: HexColor('#00C6AD'),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 207,
              height: 178,
              child: Image(
                filterQuality: FilterQuality.high,
                fit: BoxFit.fitHeight,
                image: AssetImage('assets/images/bg_shape.png'),
              ),
            ),
          ),
          Positioned(
            right: 64,
            bottom: 15,
            child: SizedBox(
              height: 250,
              child: AspectRatio(
                aspectRatio: 196 / 285,
                child: Hero(
                  tag: widget.consultant.firstName + widget.consultant.lastName,
                  child: Image(
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.fitHeight,
                    image: AssetImage('assets/images/' + widget.consultant.image),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 15,
              color: Colors.white,
            ),
          ),
          Positioned(
            right: 32,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: HexColor('#FFBB23'),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(
                    widget.consultant.rating.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Icon(
                    CustomIcons.star,
                    color: Colors.white,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  /// ******************************************
  /// Multi silect Check box
  /// ******************************************
  void _showMultiSelect(BuildContext context) async {
   /* multiItem = [];
    populateMultiselect();
    final items = multiItem;*/
     final items = <MultiSelectDialogItem<int>>[
       MultiSelectDialogItem(1, 'He/She is a liar.'),
       MultiSelectDialogItem(2, 'Sexual harassment.'),
       MultiSelectDialogItem(3, 'Poor communication'),
     ];

    final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
   //       initialSelectedValues: [1,2].toSet(),
        );
      },
    );

    print(selectedValues);
    //getvaluefromkey(selectedValues);
  }

  /*void getvaluefromkey(Set selection){
    if(selection != null){
      for(int x in selection.toList()){
        print(valuestopopulate[x]);
      }
    }
  }*/
  /// ********************************************

}





// ================== coped from stakeoverflow

class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.label);

  final V value;
  final String label;
}

class MultiSelectDialog<V> extends StatefulWidget {
  MultiSelectDialog({Key key, this.items, this.initialSelectedValues}) : super(key: key);

  final List<MultiSelectDialogItem<V>> items;
  final Set<V> initialSelectedValues;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = Set<V>();

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Reasons'),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: _onCancelTap,
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return CheckboxListTile(
      value: checked,
      title: Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }
}

// ===================





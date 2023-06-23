import 'package:mooweapp/export_files.dart';

class DetailCard extends StatefulWidget {
  final CreditCard? card;
  final double? sheetProgress;

  const DetailCard({Key? key, this.card, this.sheetProgress}) : super(key: key);

  @override
  _DetailCardState createState() => _DetailCardState();
}

class _DetailCardState extends State<DetailCard> {
  bool animateCardNumber = true;

  @override
  void initState() {
    // Future.delayed(const Duration(milliseconds: 1000), () => setState(() => animateCardNumber = false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.fromLTRB(Get.width * 0.1, 0, Get.width * 0.1, widget.sheetProgress! > 0.462 ? Get.width * 0.2 : Get.width * 0.1 + widget.sheetProgress! * 600),
        child: Transform.scale(
          scale: widget.sheetProgress! > 0.462 ? 1 - (widget.sheetProgress! - 0.462) : 1,
          child: FlippableWidget(
              frontWidget: FrontCard(
                card: widget.card,
                showCardNumber: true,
                animateCardNumber: animateCardNumber,
              ),
              backWidget: BackCard(card: widget.card)),
        ),
      ),
    );
  }
}

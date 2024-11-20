import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DropdownItem extends StatefulWidget {
  final String title, detail, icon;
  final bool isSelected;
  final bool forUpgrade;
  final double y, x;
  final bool isExpanded;
  const DropdownItem({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.detail,
    required this.y,
    required this.x,
    required this.icon,
    required this.isSelected,
    required this.forUpgrade,
  });

  @override
  State<DropdownItem> createState() => _DropdownItemState();
}

class _DropdownItemState extends State<DropdownItem>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return InkWell(
      child: Visibility(
        child: widget.isExpanded || widget.isSelected
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: EdgeInsets.only(
                      top: widget.isExpanded ? 10 : 0,
                      bottom: widget.isExpanded ? 10 : 0),
                  width:
                      widget.isExpanded ? (width * 0.9) - (25) : (width * 0.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Transform.translate(
                            offset: !widget.isSelected
                                ? const Offset(0, 0)
                                : Offset(widget.x, widget.y),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: SvgPicture.asset(
                                  widget.icon,
                                  fit: BoxFit.fill,
                                  height: 30,
                                  width: 30,
                                  colorFilter: const ColorFilter.mode(
                                      Colors.black, BlendMode.srcIn),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Transform.translate(
                                offset: !widget.isSelected
                                    ? const Offset(0, 0)
                                    : Offset(widget.x, widget.y),
                                child: Text(
                                  widget.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.5,
                                      color: Color.fromARGB(255, 59, 58, 58)),
                                ),
                              ),
                              widget.isExpanded
                                  ? Text(
                                      maxLines: 2,
                                      widget.detail,
                                      overflow: TextOverflow.clip,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(
                                              255, 118, 118, 118)),
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ],
                      ),
                      widget.forUpgrade
                          ? const UpgradeButton()
                          : widget.isExpanded
                              ? Container(
                                  width: 23,
                                  height: 23,
                                  decoration: BoxDecoration(
                                    color: widget.isSelected
                                        ? Colors.black
                                        : Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.black,
                                        width: 2.5,
                                        strokeAlign:
                                            BorderSide.strokeAlignOutside),
                                  ),
                                  child: widget.isSelected
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 15,
                                        )
                                      : null,
                                )
                              : const SizedBox.shrink()
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class UpgradeButton extends StatelessWidget {
  const UpgradeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
            border: Border.all(
                color: Colors.grey, strokeAlign: BorderSide.strokeAlignOutside),
          ),
          child: Center(
            child: DecoratedBox(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: Colors.black,
                        strokeAlign: BorderSide.strokeAlignOutside)),
                child: const Icon(
                  Icons.north_east_outlined,
                  size: 18,
                )),
          ),
        ),
        Container(
          height: 32,
          width: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            border: Border.all(
                color: Colors.grey, strokeAlign: BorderSide.strokeAlignOutside),
          ),
          child: const Center(
            child: Text("Upgrade",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black)),
          ),
        ),
      ],
    );
  }
}

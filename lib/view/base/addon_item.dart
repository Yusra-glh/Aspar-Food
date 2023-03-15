import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:sixam_mart/controller/item_controller.dart';

import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:sixam_mart/util/styles.dart';

class AddonItem extends StatefulWidget {
  final List<AddOns> addons;
  final String text;
  final String description;
  final ItemController itemController;
  final List<AddOns> originalList;
  AddonItem(
      {@required this.addons,
      @required this.text,
      @required this.originalList,
      @required this.description,
      this.itemController});

  @override
  State<AddonItem> createState() => _AddonItemState();
}

class _AddonItemState extends State<AddonItem> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
      Text(
        widget.text.tr,
        style: robotoBold.copyWith(fontSize: 17),
      ),
      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
      Text(widget.description.tr,
          style: robotoRegular.copyWith(color: Colors.black.withOpacity(0.6))),
      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
      ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.addons.length,
        padding:
            EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(
                vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: InkWell(
              onTap: () {
                if (!widget.itemController.checkAddOn(widget.addons[index])) {
                  widget.itemController.addAddOn(true, widget.addons[index]);
                } else if (widget.itemController.getQuantity(
                        widget.addons[index], widget.originalList) ==
                    1) {
                  widget.itemController.addAddOn(false, widget.addons[index]);
                } else {
                  widget.itemController.addAddOn(false, widget.addons[index]);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    child: Text(widget.addons[index].name.split("-*").first,
                        style: robotoRegular.copyWith(fontSize: 16)),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    child: Center(
                      child: Text(
                          '${PriceConverter.convertPrice(widget.addons[index].price)}',
                          style: robotoRegular.copyWith(fontSize: 16)),
                    ),
                  ),
                  SizedBox(
                    width: kIsWeb
                        ? MediaQuery.of(context).size.width / 12
                        : MediaQuery.of(context).size.width / 4,
                    child: widget.description == "Choisissez vos boissons"
                        ? Container(
                            width: widget.itemController
                                    .checkAddOn(widget.addons[index])
                                ? 15
                                : 35,
                            height: 25,
                            decoration: BoxDecoration(
                                color: widget.itemController
                                        .checkAddOn(widget.addons[index])
                                    ? Theme.of(context).backgroundColor
                                    : null,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                widget.itemController
                                        .checkAddOn(widget.addons[index])
                                    ? Container(
                                        height: 25,
                                        width: 60,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.RADIUS_SMALL),
                                            color: Theme.of(context)
                                                .backgroundColor),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    if (widget.itemController
                                                            .getQuantity(
                                                                widget.addons[
                                                                    index],
                                                                widget
                                                                    .originalList) >
                                                        1) {
                                                      widget.itemController
                                                          .setAddOnQuantity(
                                                              false,
                                                              widget.addons[
                                                                  index],
                                                              widget
                                                                  .originalList);
                                                    } else {
                                                      widget.itemController
                                                          .addAddOn(
                                                              false,
                                                              widget.addons[
                                                                  index]);
                                                    }
                                                  },
                                                  child: Center(
                                                      child: Icon(Icons.remove,
                                                          size: 19)),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 7),
                                                child: Text(
                                                  widget.itemController
                                                      .getQuantity(
                                                          widget.addons[index],
                                                          widget.originalList)
                                                      .toString(),
                                                  style: robotoMedium.copyWith(
                                                      fontSize: 17),
                                                ),
                                              ),
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () => widget
                                                      .itemController
                                                      .setAddOnQuantity(
                                                          true,
                                                          widget.addons[index],
                                                          widget.originalList),
                                                  child: Center(
                                                      child: Icon(Icons.add,
                                                          size: 19)),
                                                ),
                                              ),
                                            ]),
                                      )
                                    : SizedBox(),
                                Container(
                                  width: 25,
                                  height: 22,
                                  decoration: BoxDecoration(
                                      color: widget.itemController
                                              .checkAddOn(widget.addons[index])
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).disabledColor,
                                      border: Border.all(
                                        color: widget.itemController.checkAddOn(
                                                widget.addons[index])
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context).disabledColor,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6))),
                                  child: widget.itemController
                                          .checkAddOn(widget.addons[index])
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 4),
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        )
                                      : null,
                                ),
                              ],
                            ),
                          )
                        : Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: 25,
                              height: 22,
                              decoration: BoxDecoration(
                                  color: widget.itemController
                                          .checkAddOn(widget.addons[index])
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).disabledColor,
                                  border: Border.all(
                                    color: widget.itemController
                                            .checkAddOn(widget.addons[index])
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context).disabledColor,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6))),
                              child: widget.itemController
                                      .checkAddOn(widget.addons[index])
                                  ? Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      Padding(
        padding:
            EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        child: Divider(
            thickness: 1, color: Theme.of(context).hintColor.withOpacity(0.5)),
      )
    ]);
  }
}

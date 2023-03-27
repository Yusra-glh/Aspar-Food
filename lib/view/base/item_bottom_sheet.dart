import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/cart_controller.dart';
import 'package:sixam_mart/controller/item_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/wishlist_controller.dart';
import 'package:sixam_mart/data/model/response/cart_model.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/addon_item.dart';
import 'package:sixam_mart/view/base/confirmation_dialog.dart';
import 'package:sixam_mart/view/base/custom_button.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/discount_tag.dart';
import 'package:sixam_mart/view/base/quantity_button.dart';
import 'package:sixam_mart/view/base/rating_bar.dart';
import 'package:sixam_mart/view/screens/checkout/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'cart_snackbar.dart';

class ItemBottomSheet extends StatefulWidget {
  final Item item;
  final bool isCampaign;
  final CartModel cart;
  final int cartIndex;
  final bool inStorePage;
  ItemBottomSheet(
      {@required this.item,
      this.isCampaign = false,
      this.cart,
      this.cartIndex,
      this.inStorePage = false});

  @override
  State<ItemBottomSheet> createState() => _ItemBottomSheetState();
}

class _ItemBottomSheetState extends State<ItemBottomSheet> {
  @override
  void initState() {
    super.initState();

    Get.find<ItemController>().initData(widget.item, widget.cart);
  }

  Widget _addToCartButton(int _stock, ItemController itemController,
      double priceWithAddons, CartModel _cartModel, bool _isAvailable) {
    return (!widget.item.scheduleOrder && !_isAvailable)
        ? SizedBox()
        : Container(
            width: Dimensions.WEB_MAX_WIDTH,
            alignment: Alignment.center,
            padding: ResponsiveHelper.isDesktop(context)
                ? null
                : EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: Row(children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(50, 50),
                  backgroundColor: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    side: BorderSide(
                        width: 2, color: Theme.of(context).primaryColor),
                  ),
                ),
                onPressed: () {
                  if (widget.inStorePage) {
                    Get.back();
                  } else {
                    Get.offNamed(
                        RouteHelper.getStoreRoute(widget.item.storeId, 'item'));
                  }
                },
                child: Image.asset(Images.house,
                    color: Theme.of(context).primaryColor,
                    height: 30,
                    width: 30),
              ),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
              Expanded(
                  child: CustomButton(
                width: ResponsiveHelper.isDesktop(context)
                    ? MediaQuery.of(context).size.width / 2.0
                    : null,
                /*buttonText: isCampaign ? 'order_now'.tr : isExistInCart ? 'already_added_in_cart'.tr : fromCart
                        ? 'update_in_cart'.tr : 'add_to_cart'.tr,*/
                buttonText: (Get.find<SplashController>()
                            .configModel
                            .moduleConfig
                            .module
                            .stock &&
                        _stock <= 0)
                    ? 'out_of_stock'.tr
                    : widget.isCampaign
                        ? 'order_now'.tr
                        : (widget.cart != null ||
                                itemController.cartIndex != -1)
                            ? 'update_in_cart'.tr
                            : '${'add_to_cart'.tr + " " + PriceConverter.convertPrice(priceWithAddons) + " "}',
                onPressed: (Get.find<SplashController>()
                            .configModel
                            .moduleConfig
                            .module
                            .stock &&
                        _stock <= 0)
                    ? null
                    : () {
                        Get.back();
                        if (widget.isCampaign) {
                          Get.toNamed(RouteHelper.getCheckoutRoute('campaign'),
                              arguments: CheckoutScreen(
                                storeId: null, fromCart: false, cartList: [_cartModel],
                              ));
                        } else {
                          if (Get.find<CartController>().existAnotherStoreItem(_cartModel.item.storeId)) {
                            Get.dialog(
                                ConfirmationDialog(
                                  icon: Images.warning,
                                  title: 'are_you_sure_to_reset'.tr,
                                  description: Get.find<SplashController>()
                                          .configModel
                                          .moduleConfig
                                          .module
                                          .showRestaurantText
                                      ? 'if_you_continue'.tr
                                      : 'if_you_continue_without_another_store'
                                          .tr,
                                  onYesPressed: () {
                                    Get.back();
                                    Get.find<CartController>()
                                        .removeAllAndAddToCart(_cartModel);
                                    // showCartSnackBar(context);
                                  },
                                ),
                                barrierDismissible: false);
                          } else {
                            Get.find<CartController>().addToCart(
                              _cartModel,
                              widget.cartIndex != null
                                  ? widget.cartIndex
                                  : itemController.cartIndex,
                            );
                            //  showCartSnackBar(context);
                          }
                        }
                      },
              )),
            ]),
          );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        expand: true,
        initialChildSize: 1,
        // maxChildSize: 1.0,
        // minChildSize: 0.75.h,

        builder: (_, _controller) => Container(
              margin: EdgeInsets.only(top: GetPlatform.isWeb ? 0 : 30),
              padding: EdgeInsets.only(
                left: Dimensions.PADDING_SIZE_DEFAULT,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: ResponsiveHelper.isMobile(context)
                    ? BorderRadius.vertical(top: Radius.circular(0))
                    : BorderRadius.all(
                        Radius.circular(Dimensions.RADIUS_EXTRA_LARGE)),
              ),
              child: GetBuilder<ItemController>(builder: (itemController) {
                double _startingPrice;
                double _endingPrice;
                if (widget.item.choiceOptions.length != 0) {
                  List<double> _priceList = [];
                  widget.item.variations
                      .forEach((variation) => _priceList.add(variation.price));
                  _priceList.sort((a, b) => a.compareTo(b));
                  _startingPrice = _priceList[0];
                  if (_priceList[0] < _priceList[_priceList.length - 1]) {
                    _endingPrice = _priceList[_priceList.length - 1];
                  }
                } else {
                  _startingPrice = widget.item.price;
                }

                List<String> _variationList = [];
                for (int index = 0;
                    index < widget.item.choiceOptions.length;
                    index++) {
                  _variationList.add(widget.item.choiceOptions[index]
                      .options[itemController.variationIndex[index]]
                      .replaceAll(' ', ''));
                }
                String variationType = '';
                bool isFirst = true;
                _variationList.forEach((variation) {
                  if (isFirst) {
                    variationType = '$variationType$variation';
                    isFirst = false;
                  } else {
                    variationType = '$variationType-$variation';
                  }
                });

                double price = widget.item.price;
                Variation _variation;
                int _stock = widget.item.stock;
                for (Variation variation in widget.item.variations) {
                  if (variation.type == variationType) {
                    price = variation.price;
                    _variation = variation;
                    _stock = variation.stock;
                    break;
                  }
                }

                double _discount =
                    (widget.isCampaign || widget.item.storeDiscount == 0)
                        ? widget.item.discount
                        : widget.item.storeDiscount;
                String _discountType =
                    (widget.isCampaign || widget.item.storeDiscount == 0)
                        ? widget.item.discountType
                        : 'percent';
                double priceWithDiscount = PriceConverter.convertWithDiscount(
                    price, _discount, _discountType);
                double priceWithQuantity =
                    priceWithDiscount * itemController.quantity;
                double addonsCost = 0;
                List<AddOn> _addOnIdList = [];
                List<AddOns> _addOnsList = [];
                List<AddOns> boissons = [];
                List<AddOns> supplements = [];
                List<AddOns> fromage = [];
                List<AddOns> charcuterie = [];
                List<AddOns> sauces = [];
                for (int index = 0;
                    index < widget.item.addOns.length;
                    index++) {
                  if (itemController.checkAddOn(widget.item.addOns[index])) {
                    addonsCost = addonsCost +
                        (widget.item.addOns[index].price *
                            itemController.getQuantity(
                                widget.item.addOns[index], widget.item.addOns));
                    _addOnIdList.add(AddOn(
                        id: widget.item.addOns[index].id,
                        quantity: itemController.getQuantity(
                            widget.item.addOns[index], widget.item.addOns)));
                    _addOnsList.add(widget.item.addOns[index]);
                  }

                  if (widget.item.addOns[index].name.contains("boissons")) {
                    boissons.add(widget.item.addOns[index]);
                  } else if (widget.item.addOns[index].name
                      .contains("suppléments")) {
                    supplements.add(widget.item.addOns[index]);
                  } else if (widget.item.addOns[index].name
                      .contains("fromages")) {
                    fromage.add(widget.item.addOns[index]);
                  } else if (widget.item.addOns[index].name
                      .contains("charcuterie")) {
                    charcuterie.add(widget.item.addOns[index]);
                  } else if (widget.item.addOns[index].name
                      .contains("sauces")) {
                    sauces.add(widget.item.addOns[index]);
                  }
                }
                double priceWithAddons = priceWithQuantity +
                    (Get.find<SplashController>()
                            .configModel
                            .moduleConfig
                            .module
                            .addOn
                        ? addonsCost
                        : 0);
                // bool _isRestAvailable = DateConverter.isAvailable(widget.product.restaurantOpeningTime, widget.product.restaurantClosingTime);
                bool _isAvailable = DateConverter.isAvailable(
                    widget.item.availableTimeStarts,
                    widget.item.availableTimeEnds);

                CartModel _cartModel = CartModel(
                          price, priceWithDiscount, _variation != null ? [_variation] : [], itemController.selectedVariations,
                          (price - PriceConverter.convertWithDiscount(price, _discount, _discountType)),
                          itemController.quantity, _addOnIdList, _addOnsList, widget.isCampaign, _stock, widget.item,
                        );

                return Scaffold(
                  body: Container(
                    color: Theme.of(context).cardColor,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  InkWell(
                                      onTap: () => Get.back(),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: Dimensions
                                                .PADDING_SIZE_EXTRA_LARGE,
                                            right: Dimensions
                                                .PADDING_SIZE_EXTRA_SMALL),
                                        child: Icon(Icons.close),
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: Dimensions.PADDING_SIZE_DEFAULT,
                                      top: ResponsiveHelper.isDesktop(context)
                                          ? 0
                                          : Dimensions.PADDING_SIZE_DEFAULT,
                                    ),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //Product
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onTap: widget.isCampaign
                                                      ? null
                                                      : () {
                                                          if (!widget
                                                              .isCampaign) {
                                                            Get.toNamed(RouteHelper
                                                                .getItemImagesRoute(
                                                                    widget
                                                                        .item));
                                                          }
                                                        },
                                                  child: Stack(children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius
                                                          .circular(Dimensions
                                                              .RADIUS_SMALL),
                                                      child: CustomImage(
                                                        image:
                                                            '${widget.isCampaign ? Get.find<SplashController>().configModel.baseUrls.campaignImageUrl : Get.find<SplashController>().configModel.baseUrls.itemImageUrl}/${widget.item.image}',
                                                        width: ResponsiveHelper
                                                                .isMobile(
                                                                    context)
                                                            ? MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width
                                                            : MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width,
                                                        height: ResponsiveHelper
                                                                .isMobile(
                                                                    context)
                                                            ? MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.25
                                                            : MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.25,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                    DiscountTag(
                                                        discount: _discount,
                                                        discountType:
                                                            _discountType,
                                                        fromTop: 20),
                                                  ]),
                                                ),
                                                SizedBox(width: 10),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20.0),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              widget.item.name,
                                                              style: robotoMedium
                                                                  .copyWith(
                                                                      fontSize:
                                                                          Dimensions
                                                                              .fontSizeExtraLarge),
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            widget.isCampaign
                                                                ? SizedBox(
                                                                    height: 25)
                                                                : GetBuilder<
                                                                        WishListController>(
                                                                    builder:
                                                                        (wishList) {
                                                                    return InkWell(
                                                                      onTap:
                                                                          () {
                                                                        if (Get.find<AuthController>()
                                                                            .isLoggedIn()) {
                                                                          wishList.wishItemIdList.contains(widget.item.id)
                                                                              ? wishList.removeFromWishList(widget.item.id, false)
                                                                              : wishList.addToWishList(widget.item, null, false);
                                                                        } else {
                                                                          showCustomSnackBar(
                                                                              'you_are_not_logged_in'.tr);
                                                                        }
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        wishList.wishItemIdList.contains(widget.item.id)
                                                                            ? Icons.favorite
                                                                            : Icons.favorite_border,
                                                                        color: wishList.wishItemIdList.contains(widget.item.id)
                                                                            ? Theme.of(context).primaryColor
                                                                            : Theme.of(context).disabledColor,
                                                                      ),
                                                                    );
                                                                  }),
                                                          ],
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            if (widget
                                                                .inStorePage) {
                                                              Get.back();
                                                            } else {
                                                              Get.offNamed(RouteHelper
                                                                  .getStoreRoute(
                                                                      widget
                                                                          .item
                                                                          .storeId,
                                                                      'item'));
                                                            }
                                                          },
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    0, 8, 5, 8),
                                                            child: Text(
                                                              widget.item
                                                                  .storeName,
                                                              style: robotoRegular.copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeDefault,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                            ),
                                                          ),
                                                        ),
                                                        //  RatingBar(
                                                        //   rating: widget.item.avgRating,
                                                        // size: 15,
                                                        //ratingCount: widget.item.ratingCount),
                                                        Text(
                                                          '${PriceConverter.convertPrice(_startingPrice, discount: _discount, discountType: _discountType)}'
                                                          '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(_endingPrice, discount: _discount, discountType: _discountType)}' : ''}',
                                                          style: robotoMedium
                                                              .copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeLarge),
                                                        ),
                                                        price > priceWithDiscount
                                                            ? Text(
                                                                '${PriceConverter.convertPrice(_startingPrice)}'
                                                                '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(_endingPrice)}' : ''}',
                                                                style: robotoMedium.copyWith(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .disabledColor,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough),
                                                              )
                                                            : SizedBox(),
                                                      ]),
                                                ),
                                                Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      ((Get.find<SplashController>()
                                                                      .configModel
                                                                      .moduleConfig
                                                                      .module
                                                                      .unit &&
                                                                  widget.item
                                                                          .unitType !=
                                                                      null) ||
                                                              (Get.find<SplashController>()
                                                                      .configModel
                                                                      .moduleConfig
                                                                      .module
                                                                      .vegNonVeg &&
                                                                  Get.find<
                                                                          SplashController>()
                                                                      .configModel
                                                                      .toggleVegNonVeg))
                                                          ? Container(
                                                              padding: EdgeInsets.symmetric(
                                                                  vertical:
                                                                      Dimensions
                                                                          .PADDING_SIZE_EXTRA_SMALL,
                                                                  horizontal:
                                                                      Dimensions
                                                                          .PADDING_SIZE_SMALL),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        Dimensions
                                                                            .RADIUS_SMALL),
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                              child: Text(
                                                                Get.find<SplashController>()
                                                                        .configModel
                                                                        .moduleConfig
                                                                        .module
                                                                        .unit
                                                                    ? widget.item
                                                                            .unitType ??
                                                                        ''
                                                                    : widget.item.veg ==
                                                                            0
                                                                        ? 'non_veg'
                                                                            .tr
                                                                        : 'veg'
                                                                            .tr,
                                                                style: robotoRegular.copyWith(
                                                                    fontSize:
                                                                        Dimensions
                                                                            .fontSizeExtraSmall,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            )
                                                          : SizedBox(),
                                                      SizedBox(
                                                          height: Get.find<
                                                                      SplashController>()
                                                                  .configModel
                                                                  .toggleVegNonVeg
                                                              ? 50
                                                              : 0),
                                                    ]),
                                              ]),

                                          SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_SMALL),

                                          (widget.item.description != null &&
                                                  widget.item.description
                                                      .isNotEmpty)
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Text('description'.tr, style: robotoMedium),
                                                    // SizedBox(
                                                    //  height:
                                                    //   Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                    Text(
                                                        widget.item.description,
                                                        style: robotoRegular),
                                                    SizedBox(
                                                        height: Dimensions
                                                            .PADDING_SIZE_LARGE),
                                                  ],
                                                )
                                              : SizedBox(),

                                          // Variation
                                          /* ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: widget.item.choiceOptions.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(widget.item.choiceOptions[index].title,
                                                style: robotoMedium),
                                            SizedBox(
                                                height:
                                                    Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                    
                                            GridView.builder(
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount:
                                                    ResponsiveHelper.isMobile(context)
                                                        ? 3
                                                        : 4,
                                                crossAxisSpacing: 20,
                                                mainAxisSpacing: 10,
                                                childAspectRatio: (1 / 0.25),
                                              ),
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              padding: EdgeInsets.zero,
                                              itemCount: widget.item.choiceOptions[index]
                                                  .options.length,
                                              itemBuilder: (context, i) {
                                                return 
                                                
                                                InkWell(
                                                  onTap: () {
                                                    itemController.setCartVariationIndex(
                                                        index, i, widget.item);
                                                  },
                                                  child: 
                                                     Container(
                                                      width: 20,
                                                      height: 20,
                                                   decoration: BoxDecoration(
                                                  color: itemController.variationIndex[
                                                                      index] !=
                                                                  i
                                                              ? Theme.of(context)
                                                                  .backgroundColor
                                                              : Theme.of(context)
                                                                  .primaryColor,
                                                   border: Border.all(
                                                  color:itemController.variationIndex[
                                                                      index] !=
                                                                  i
                                                              ? Theme.of(context)
                                                                  .backgroundColor
                                                              : Theme.of(context)
                                                                  .primaryColor,
                                               ),
                                                borderRadius: BorderRadius.all(Radius.circular(5))))
                                                
                                                );
                                              },
                                            ),
                                            SizedBox(
                                                height: index !=
                                                        widget.item.choiceOptions.length -
                                                            1
                                                    ? Dimensions.PADDING_SIZE_LARGE
                                                    : 0),
                                          ]);
                                    },
                                  ),
                                  SizedBox(
                                      height: widget.item.choiceOptions.length > 0
                                          ? Dimensions.PADDING_SIZE_LARGE
                                          : 0),*/

                                          // Addons
                                          //********************************************************************************************************** */
                                          if (Get.find<SplashController>()
                                                  .configModel
                                                  .moduleConfig
                                                  .module
                                                  .addOn &&
                                              widget.item.addOns.length > 0)
                                                 if (supplements.isNotEmpty)
                                            AddonItem(
                                              itemController: itemController,
                                              text: "Suppléments aux choix",
                                              description:
                                                  "Choisissez vos suppléments",
                                              originalList: widget.item.addOns,
                                              addons: supplements,
                                            ),
                                            if (sauces.isNotEmpty)
                                              AddonItem(
                                                itemController: itemController,
                                                text: "Sauces aux choix",
                                                description:
                                                    "Choisissez vos sauces",
                                                originalList:
                                                    widget.item.addOns,
                                                addons: sauces,
                                              ),
                                          if (charcuterie.isNotEmpty)
                                            AddonItem(
                                              itemController: itemController,
                                              text: "Charcuteries aux choix",
                                              description:
                                                  "Choisissez vos charcuteries",
                                              originalList: widget.item.addOns,
                                              addons: charcuterie,
                                            ),
                                       
                                          if (fromage.isNotEmpty)
                                            AddonItem(
                                              itemController: itemController,
                                              text: "Fromages aux choix",
                                              description:
                                                  "Choisissez vos fromages",
                                              originalList: widget.item.addOns,
                                              addons: fromage,
                                            ),
                                          if (boissons.isNotEmpty)
                                            AddonItem(
                                              itemController: itemController,
                                              text: "Boissons aux choix",
                                              description:
                                                  "Choisissez vos boissons",
                                              originalList: widget.item.addOns,
                                              addons: boissons,
                                            ),
                                          //******************************************************************************************************* */
                                          // Text(PriceConverter.convertPrice(priceWithAddons),
                                          //  style: robotoBold.copyWith(
                                          // color: Theme.of(context).primaryColor)),

                                          // Quantity
                                          SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_EXTRA_LARGE),
                                          Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                QuantityButton(
                                                  onTap: () {
                                                    if (itemController
                                                            .quantity >
                                                        1) {
                                                      itemController
                                                          .setQuantity(
                                                              false, _stock);
                                                    }
                                                  },
                                                  isIncrement: false,
                                                  width: 30,
                                                  height: 30,
                                                  size: 17,
                                                ),
                                                Text(
                                                    itemController.quantity
                                                        .toString(),
                                                    style: robotoMedium.copyWith(
                                                        fontSize: Dimensions
                                                                .fontSizeLarge *
                                                            1.5)),
                                                QuantityButton(
                                                  onTap: () => itemController
                                                      .setQuantity(
                                                          true, _stock),
                                                  isIncrement: true,
                                                  width: 30,
                                                  height: 30,
                                                  size: 17,
                                                ),
                                              ]),

                                          SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_LARGE),

                                          //Add to cart Button

                                          _isAvailable
                                              ? SizedBox()
                                              : Container(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.all(
                                                      Dimensions
                                                          .PADDING_SIZE_SMALL),
                                                  margin: EdgeInsets.only(
                                                      bottom: Dimensions
                                                          .PADDING_SIZE_SMALL),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimensions
                                                                .RADIUS_SMALL),
                                                    color: Theme.of(context)
                                                        .primaryColor
                                                        .withOpacity(0.1),
                                                  ),
                                                  child: Column(children: [
                                                    Text('not_available_now'.tr,
                                                        style: robotoMedium
                                                            .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontSize: Dimensions
                                                              .fontSizeLarge,
                                                        )),
                                                    Text(
                                                      '${'available_will_be'.tr} ${DateConverter.convertTimeToTime(widget.item.availableTimeStarts)} '
                                                      '- ${DateConverter.convertTimeToTime(widget.item.availableTimeEnds)}',
                                                      style: robotoRegular,
                                                    ),
                                                  ]),
                                                ),
                                        ]),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.0,
                                  )
                                ]),
                          ),
                        ),
                        _addToCartButton(_stock, itemController,
                            priceWithAddons, _cartModel, _isAvailable)
                      ],
                    ),
                  ),
                );
              }),
            ));
  }
}

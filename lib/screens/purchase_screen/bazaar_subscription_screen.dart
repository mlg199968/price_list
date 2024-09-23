import 'package:flutter/material.dart';
import 'package:flutter_poolakey/flutter_poolakey.dart';
import 'package:gap/gap.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:price_list/providers/value_provider.dart';
import 'package:price_list/screens/purchase_screen/bazaar_purchase_screen.dart';
import 'package:price_list/screens/purchase_screen/services/bazaar_api.dart';
import 'package:price_list/screens/purchase_screen/services/purchase_tools.dart';
import 'package:provider/provider.dart';
import '../../../components/action_button.dart';
import '../../../components/custom_text.dart';
import '../../../components/dynamic_button.dart';
import '../../../components/empty_holder.dart';
import '../../../constants/constants.dart';
import '../../../model/subscription.dart';
import '../../../providers/user_provider.dart';

class BazaarSubscriptionScreen extends StatefulWidget {
  static const String id = '/bazaar-subscription-screen';
  const BazaarSubscriptionScreen({super.key});

  @override
  State<BazaarSubscriptionScreen> createState() => _BazaarSubscriptionScreenState();
}

class _BazaarSubscriptionScreenState extends State<BazaarSubscriptionScreen> {
late UserProvider provider;
bool removeDevice=false;
late Future getList;
  @override
  void initState() {
    getList=BazaarApi.getPurchasesList();
    provider=Provider.of<UserProvider>(context,listen: false);
    fetchSubs(provider.subscription, provider);
    super.initState();
  }
  ///
 Future<void> fetchSubs(Subscription? subs,UserProvider uProvider) async {
   getList=BazaarApi.getPurchasesList();
        setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider,ValueProvider>(builder: (context, userProvider,valProvider, child) {
      Subscription? subs = userProvider.subscription;
      return Scaffold(
        extendBodyBehindAppBar: true,
        ///appbar
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text("وضعیت اشتراک"),
          actions: [
            DynamicButton(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              label: "تازه سازی",
              icon: Icons.refresh_rounded,
              bgColor: Colors.black12,
              iconColor: Colors.teal,
              onPress: () async {
                await fetchSubs(subs, userProvider);
              },
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 80),
          alignment: Alignment.topCenter,
          decoration: const BoxDecoration(gradient: kMainGradiant),
          child: FutureBuilder(
            future: getList,
            builder: (context,future) {

              ///loading data show circle indicator
              if(future.connectionState==ConnectionState.waiting){
                return SizedBox(
                  height: 80,
                    width: 80,
                    child: Center(child: CircularProgressIndicator(color: Colors.white70,)));
              }
              ///show data
              else if(future.connectionState==ConnectionState.done) {
                List<PurchaseInfo>? subsList =future.data;
                bool isPurchased=BazaarApi().checkSubscribe(context, subsList) ?? false;
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child:SingleChildScrollView(
                        child: Column(
                          children: [
                            ///subs active or not active
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(20),
                              width: double.maxFinite,
                              decoration: BoxDecoration(color: (isPurchased?Colors.green[700]:Colors.red)!.withOpacity(.9)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(isPurchased?Icons.check_circle:Icons.remove_circle,
                                    color: Colors.white70,
                                    size: 20,
                                  ),
                                  Gap(5),
                                  CText(isPurchased?"اشتراک برای شما فعال است":"اشتراک فعالی یافت نشد",
                                    color: Colors.white,
                                  )
                                ],
                              )
                            ),
                
                            ///action buttons
                            Wrap(
                              children: [
                                ActionButton(
                                  label: "خرید اشتراک جدید",
                                  icon: Icons.stars,
                                  borderRadius: 30,
                                  bgColor: Colors.black54,
                                  borderColor: Colors.amberAccent,
                                  iconColor: Colors.amberAccent,
                                  onPress: () {
                                    Navigator.pushNamed(
                                        context, BazaarPurchaseScreen.id);
                                  },
                                ),
                              ],
                            ),
                
                            ///plans list
                            PlanListPart(subsList: subsList),
                          ],
                        ),
                      ),
                );
                }
              else{
                return EmptyHolder(text: "خطا در برقراری ارتباط", icon: Icons.signal_wifi_connected_no_internet_4);
              }
              }
          ),
        ),
      );
    });
  }
}

class PlanListPart extends StatefulWidget {
  const PlanListPart({
    super.key,
    required this.subsList,
  });
  final List<PurchaseInfo>? subsList;
  @override
  State<PlanListPart> createState() => _PlanListPartState();
}

class _PlanListPartState extends State<PlanListPart> {
  bool isCollapse = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: kBlackWhiteGradiant,
        color: Colors.white70,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              isCollapse = !isCollapse;
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration:
                  const BoxDecoration(border: Border(bottom: BorderSide())),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CText(
                    "اشتراک های خریداری شده",
                    fontSize: 14,
                  ),
                  const Expanded(child: SizedBox()),
                  Icon(
                    isCollapse
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_up_rounded,
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 500),
            child: SizedBox(
              height: isCollapse ? 150 : null,
              child: (widget.subsList == null || widget.subsList!.isEmpty)
                  ? const EmptyHolder(
                      height: 150,
                      text: "اشتراکی یافت نشد",
                      icon: Icons.timelapse_rounded,
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:
                            List.generate(widget.subsList!.length, (index) {
                              PurchaseInfo plan = widget.subsList![index];
                              String planTitle=PurchaseTools.convertPlan(plan.productId)["title"];
                              List<Color> planColors=PurchaseTools.convertPlan(plan.productId)["colors"];
                          return Container(
                            height: 50,
                            alignment: Alignment.topCenter,
                            margin: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white70,
                              gradient: LinearGradient(colors: planColors)
                            ),
                            child: ListTile(
                              dense: true,
                              titleAlignment: ListTileTitleAlignment.titleHeight,
                              // contentPadding: EdgeInsets.zero,
                              leading: const Icon(
                                Icons.stars,
                                color: Colors.amber,
                              ),
                              title: CText("اشتراک $planTitle",color: Colors.white,),
                              subtitle: CText(
                                  "${plan.orderId}",fontSize: 11),
                              trailing: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CText(
                                    DateTime.fromMillisecondsSinceEpoch(plan.purchaseTime).toPersianDate(),
                                    color: Colors.black54,
                                    fontSize: 11,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ///price text
                                      CText(
                                        plan.payload,
                                        fontSize: 14,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).reversed.toList(),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

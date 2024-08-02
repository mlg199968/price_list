import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:price_list/screens/purchase_screen/plan_screen.dart';
import 'package:price_list/screens/purchase_screen/widgets/subscription_timer.dart';
import 'package:price_list/screens/ware_list/ware_list_screen.dart';
import 'package:provider/provider.dart';
import '../../../components/action_button.dart';
import '../../../components/custom_alert.dart';
import '../../../components/custom_text.dart';
import '../../../components/dynamic_button.dart';
import '../../../components/empty_holder.dart';
import '../../../constants/constants.dart';
import '../../../constants/utils.dart';
import '../../../model/subscription.dart';
import '../../../model/plan.dart';
import '../../../providers/user_provider.dart';
import '../../../services/backend_services.dart';

class SubscriptionScreen extends StatefulWidget {
  static const String id = '/subscription-screen';
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
late UserProvider provider;
  @override
  void initState() {
    provider=Provider.of<UserProvider>(context,listen: false);
    fetchSubs(provider.subscription, provider);
    super.initState();
  }
  ///
 Future<void> fetchSubs(Subscription? subs,UserProvider uProvider) async {
    if(subs!=null) {
      Map map = await BackendServices.readSubs(context, subs.phone,
          subsId: subs.id.toString());
      if (map["success"] == true) {
        uProvider.setSubscription(map["subs"]);
        if (context.mounted) {
          BackendServices.updateFetchDate(context, map["subs"]);
        }
        setState(() {});
      }
    }
    else{
      showSnackBar(context, "حساب کاربری یافت نشد");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
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
        ///body
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.only(top: 80),
            alignment: Alignment.topCenter,
            decoration: const BoxDecoration(gradient: kMainGradiant),
            child: Builder(
              builder: (context) {
                if(subs!=null) {
                  return SingleChildScrollView(
                  child: Column(
                    children: [
                      ///subs user detail
                      Container(
                          margin: const EdgeInsets.all(10),
                          width: 500,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            gradient: kBlackWhiteGradiant,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                               Flexible(
                                child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        const Icon(
                                          Icons.person,
                                          size: 180,
                                        ),
                                        ///subs id
                                        CText(subs.id.toString(),color: Colors.white70,),
                                      ],
                                    )),
                              ),
                              Flexible(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CText(subs.name,
                                        fontSize: 17, color: Colors.black87),
                                    CText(subs.phone),
                                    CText(subs.email, color: Colors.black87),
                                    CText(
                                      "تاریخ ثبت: ${subs.startDate?.toPersianDateStr()}",
                                      color: Colors.black54,
                                      fontSize: 10,
                                    ),
                                    const Gap(10),
                                    SubscriptionDeadLine(
                                      endDate: subs.endDate,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                      ///action buttons
                      Wrap(
                        children: [
                          ActionButton(
                            label: "خروج از حساب اشتراکی",
                            icon: Icons.logout,
                            borderRadius: 5,
                            bgColor: Colors.redAccent,
                            onPress: (){
                              showDialog(context: context, builder: (_)=>CustomAlert(
                                title: "آیا از خروج از حساب اشتراکی مطمئن هستید؟",
                                onYes: (){
                                  userProvider.setSubscription(null);
                                  setState(() {});
                                  Navigator.pushNamedAndRemoveUntil(context, WareListScreen.id, (route) => false);
                                },),
                              );
                            },
                          ),
                          ActionButton(
                            label: "خرید اشتراک جدید",
                            icon: Icons.stars,
                            borderRadius: 5,
                            bgColor: Colors.deepPurple.withOpacity(.8),
                            iconColor: Colors.amberAccent,
                            onPress: (){
                              Navigator.pushNamed(context, PlanScreen.id,arguments: {"phone": subs.phone,"subsId":subs.id,"oldSubs":subs});
                            },
                          ),
                        ],
                      ),
                      ///plans list
                      PlanListPart(planList: subs.planList),
                    ],
                  ),
                );
                }
                else{
                  return const EmptyHolder(text: "حساب کاربری یافت نشد", icon: Icons.person_search_rounded,color: Colors.white70,iconSize: 50);
                }
              }
            ),
          ),
        ),
      );
    });
  }
}

class PlanListPart extends StatefulWidget {
  const PlanListPart({
    super.key,
    required this.planList,
  });
  final List<Plan>? planList;
  @override
  State<PlanListPart> createState() => _PlanListPartState();
}

class _PlanListPartState extends State<PlanListPart> {
  bool isCollapse = true;

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
              child: (widget.planList == null || widget.planList!.isEmpty)
                  ? const EmptyHolder(
                      height: 150,
                      text: "اشتراکی یافت نشد",
                      icon: Icons.timelapse_rounded,
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:
                            List.generate(widget.planList!.length, (index) {
                          Plan plan = widget.planList![index];
                          return Container(
                            margin: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white),
                            child: ListTile(
                              leading: const Icon(
                                Icons.stars,
                                color: Colors.amber,
                              ),
                              title: CText("اشتراک ${plan.title}"),
                              subtitle: CText(
                                  "${plan.refId ?? ""} - ${plan.description ?? ""}"),
                              trailing: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CText(
                                    plan.startDate?.toPersianDate(),
                                    color: Colors.black54,
                                    fontSize: 11,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ///discount red holder
                                      if (plan.hasDiscount)
                                        Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: CText(
                                              "${plan.discount}%"
                                                  .toPersianDigit(),
                                              fontSize: 10,
                                              color: Colors.white,
                                            )),

                                      ///price text
                                      CText(
                                        addSeparator(plan.price),
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



  enum SortItem{
  createdDate("تاریخ ثبت"),
  modifiedDate("تاریخ ویرایش"),
  name("حروف الفبا"),
  custom("ترتیب شخصی"),
  price("قیمت"),
  amount("موجودی");
  const SortItem(this.value);
  final String value;
}
  enum ListViewMode{
  grid("شبکه ای"),
  list("ردیفی");
  const ListViewMode(this.value);
  final String value;
}

///message type for snackbar
  enum SnackType{
    normal,
    success,
    warning,
    error,
  }
  enum ScreenType{
    mobile,
    tablet,
    desktop
  }

  enum AppType{
  waiter("waiter"),
    main("main");
    const AppType(this.value);
   final String value;
  }

 enum PackType{
  order("order"),
    itemList("itemList"),
    wareList("wareList"),
    respond("respond");
    const PackType(this.value);
   final String value;
  }

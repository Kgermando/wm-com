class InfoSystem {
  String name() => "Work Management";
  String namelong() => "Solution Work Management";
  String description() => "Work Management pour entreprise priveée et public"; 
  String version() => "1.0.0.0";
  String logo() => "assets/images/logo.png";
  String logoSansFond() => "assets/images/logo_sans_fond.png";
  String logoIcon() => "assets/images/logo_icon.png";

  // Entreprise
  static const variable = 'commercial';
  String business() => variable;
  String nameClient() => "commercial";
  String nameAdress() =>
      "No 163 avenue Kasai, Gombe, Q/ Gard - RDC";
  String logoClient() => "assets/images/logo.png";
  String prefix() => "WM";
  String rccm() => "20-A-02375";
  String nImpot() => "A2150314N";
  String iDNat() => "-";
  String email() => "-";
  String phone() => "+243 99 150 93 03";
   
  String date() => "30-03-2023";

//  Local Storage
  static const keyUser = 'userModel$variable';
  static const keyIdToken = 'idToken$variable';
  static const keyAccessToken = 'accessToken$variable';
  static const keyRefreshToken = 'refreshToken$variable';
  
  static const keyDateLogged = 'dateLogged';
}

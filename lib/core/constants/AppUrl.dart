class Appurl {
  static final String _BASEURL = "https://api.coingecko.com/api/v3";

  static String _getUrl(String endpoint) {
    return '$_BASEURL/$endpoint';
  }


  static String getAllCoinsListUrl = _getUrl("coins/list");
  static String fetchPrizes = _getUrl("simple/") ;

}

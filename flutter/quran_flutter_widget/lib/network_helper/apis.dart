class Apis extends Object {
  static const int single = 1;
  static const int list = 2;

  //states
  static String loadingState = 'LoadingState';
  static String dataFetchedState = 'DataFetchedState';

  static int codeSUCCESS = 200;
  static int codeERROR = 500;

  static String authorization = '';
  static String clientId = '';
  static String clientSecret = '';

  static const String baseUrl = 'https://api.otlohasah.org';

  static String get basePath => baseUrl + '/api/v1/';
  static String get imageUrl => basePath;

  static String get fetchAllNARRATIONS => '${basePath}narrations/';
  static String get fetchAllBOOKS => '${basePath}books/';
  static String get fetchAllCHAPTERS => '${basePath}chapters/';
  static String get fetchAllPARTS => '${basePath}parts/';
  static String get fetchAllPAGES => '${basePath}pages/';
  static String get fetchAllRECITATIONS => '${basePath}recitations/';
  static String get fetchAllRECITERS => '${basePath}reciters/';
  static String get fetchAllTRANSLATION => '${basePath}translations/';
  static String get fetchAllTAJWEED => '${basePath}tajweed/books/';
  static String get fetchAllTAFSEER => '${basePath}explanation/';
  static String get fetchAllSEARCH => '${basePath}search/';
}

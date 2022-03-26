class Util{
  static List<String> days = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo'
    ];
    static List<String> months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];

    static String getDayOfWeekSpanish(DateTime date){
      return days[date.weekday -1];
    }
    static String getMonthSpanish(DateTime date){
      return months[date.month -1];
    }

    static String getFullDateSpanish(DateTime date){
      return getDayOfWeekSpanish(date) + " "+ date.day.toString() + " de " + getMonthSpanish(date);
    }
}

class Tags{
  static const scaleFactorTag = "SCALE_FACTOR";
  static const selectedProviderTag = "SELECTED_PROVIDER";

  static const LAST_UPDATED_TAG = "LAST_UPDATED_TAG";
  static const TEXTS_PROVIDER_TAG = "TEXTS_PROVIDER_TAG";

  static const FIRST_INDEX_TAG = "FIRST_INDEX_TAG";
  static const FIRST_TAG = "FIRST_TAG";

  static const SECOND_INDEX_TAG ="SECOND_INDEX_TAG";
  static const SECOND_TAG = "SECOND_TAG";

  static const PSALM_INDEX_TAG = "PSALM_INDEX_TAG";
  static const PSALM_RESPONSE_TAG = "PSALM_RESPONSE_TAG";
  static const PSALM_TAG = "PSALM_TAG";

  static const GODSPELL_INDEX_TAG = "GODSPELL_INDEX_TAG";
  static const GODSPELL_TAG = "GODSPELL_TAG";
}
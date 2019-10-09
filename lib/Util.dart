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
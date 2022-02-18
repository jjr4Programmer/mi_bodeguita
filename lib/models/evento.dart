class Evento {
  String fecha, hora, tipo;
  double monto;

  String getFecha() {
    var fechal = this.fecha.split('-');
    var fecha2 = fechal[2] + "-" + fechal[1];
    return fecha2;
  }

  int compareTo(Evento other) {
    if (fecha == other.fecha) {
      if (hora == other.hora) {
        return 0;
      } else {
        return hora.compareTo(other.hora);
      }
    } else if (fecha.compareTo(other.fecha) == 1) {
      return 1;
    } else {
      return -1;
    }
  }
}

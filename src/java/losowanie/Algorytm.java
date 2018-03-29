package losowanie;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class Algorytm {

    public static void main(String[] args) {

        Zawodnik z1 = new Zawodnik("Bogdan", 8, 4, 4, 2);
        Zawodnik z2 = new Zawodnik("Dejski", 9, 9, 9, 2);
        Zawodnik z3 = new Zawodnik("Jurek", 6, 4, 4, 2);
        Zawodnik z4 = new Zawodnik("Pawel", 7, 8, 7, 2);
        Zawodnik z5 = new Zawodnik("Staszek", 6, 7, 7, 2);
        Zawodnik z6 = new Zawodnik("Kajtek", 5, 7, 6, 2);
        Zawodnik z7 = new Zawodnik("LukaszR", 10, 8, 8, 2);

        List<Zawodnik> ekipa = new ArrayList<>();
        ekipa.add(z1);
        ekipa.add(z2);
        ekipa.add(z3);
        ekipa.add(z4);
        ekipa.add(z5);
        ekipa.add(z6);
        ekipa.add(z7);
        List wynik = losuj(ekipa);
        List<String> listaA = (List<String>) wynik.get(0);
        for (Iterator<String> iterator = listaA.iterator(); iterator.hasNext();) {
            String next = iterator.next();
            System.out.println(next);
        }
        System.out.println(wynik.get(1));

    }

    public static List losuj(List ekipa) {
        Map<String, Double> unsortMap = new HashMap<>();
        List<String> druzyna1 = new ArrayList<>();
        List<String> druzyna2 = new ArrayList<>();
        List<String> sumy = new ArrayList<>();
        List<String> listaPosortowana = new ArrayList<>();

        //ZAMIANA ekipy w mapę
        for (Iterator iterator = ekipa.iterator(); iterator.hasNext();) {
            Zawodnik next = (Zawodnik) iterator.next();
            //System.out.println(next.name + " " + next.ranking);
            unsortMap.put(next.name, next.ranking);
        }

        //SORTOWANIE MAPY
        Map<String, Double> ekipaPosortowana = new LinkedHashMap<>();
        unsortMap.entrySet().stream()
                .sorted(Map.Entry.<String, Double>comparingByValue().reversed())
                .forEachOrdered(x -> ekipaPosortowana.put(x.getKey(), x.getValue()));
        //System.out.println(ekipaPosortowana);
        //PRZEPISANIE Z POSORTOWANEJ MAPY DO LISTY
        ekipaPosortowana.entrySet().stream().map((entry) -> entry.getKey()).forEachOrdered((key) -> {
            listaPosortowana.add(key);
        });
        //System.out.println(listaPosortowana);
        double suma1 = 0.0;
        double suma2 = 0.0;

        //GDY ROWNA ILOSC - według max
        if ((ekipaPosortowana.size() & 1) == 0) {
            //System.out.println("PARZYSTA");
            //System.out.println(listaPosortowana.size());
            druzyna1.add(listaPosortowana.get(0));
            suma1 += unsortMap.get(listaPosortowana.get(0));
            listaPosortowana.remove(0);
            druzyna2.add(listaPosortowana.get(0));
            suma2 += unsortMap.get(listaPosortowana.get(0));
            listaPosortowana.remove(0);
            while (listaPosortowana.size() > 0) {
                druzyna1.add(listaPosortowana.get(0));
                suma1 += unsortMap.get(listaPosortowana.get(0));
                listaPosortowana.remove(0);
                druzyna2.add(listaPosortowana.get(0));
                suma2 += unsortMap.get(listaPosortowana.get(0));
                listaPosortowana.remove(0);
                if (listaPosortowana.size() == 2) {
                    druzyna2.add(listaPosortowana.get(0));
                    suma2 += unsortMap.get(listaPosortowana.get(0));
                    listaPosortowana.remove(0);
                    druzyna1.add(listaPosortowana.get(0));
                    suma1 += unsortMap.get(listaPosortowana.get(0));
                    listaPosortowana.remove(0);
                }
            }

            //GDY NIEROWNA ILOSC
        } else {
            //System.out.println("NIEPARZYSTA");
            druzyna2.add(listaPosortowana.get(0));
            suma2 += unsortMap.get(listaPosortowana.get(0));
            listaPosortowana.remove(0);
            druzyna2.add(listaPosortowana.get(0));
            suma2 += unsortMap.get(listaPosortowana.get(0));
            listaPosortowana.remove(0);
            druzyna1.add(listaPosortowana.get(0));
            suma1 += unsortMap.get(listaPosortowana.get(0));
            listaPosortowana.remove(0);
            druzyna1.add(listaPosortowana.get(0));
            suma1 += unsortMap.get(listaPosortowana.get(0));
            listaPosortowana.remove(0);
            //System.out.println("listaPosortowana.size():" + listaPosortowana.size());
            druzyna1.add(listaPosortowana.get(listaPosortowana.size() - 1));
            suma1 += unsortMap.get(listaPosortowana.get(listaPosortowana.size() - 1));
            listaPosortowana.remove(listaPosortowana.size() - 1);
            while (listaPosortowana.size() > 0) {
                druzyna2.add(listaPosortowana.get(0));
                suma2 += unsortMap.get(listaPosortowana.get(0));
                listaPosortowana.remove(0);

                druzyna1.add(listaPosortowana.get(0));
                suma1 += unsortMap.get(listaPosortowana.get(0));
                listaPosortowana.remove(0);
            }
        }

        //System.out.println(druzyna1);
        int a = (int) Math.round(suma1);
        sumy.add(Integer.toString(a));
        //System.out.println(a);
        //System.out.println(druzyna2);
        int b = (int) Math.round(suma2);
        sumy.add(Integer.toString(b));
        int roznica = a - b;
        sumy.add(Integer.toString(roznica));
        //System.out.println(b);
        List lista1 = new ArrayList();
        lista1.add(druzyna1);
        lista1.add(druzyna2);
        lista1.add(sumy);
        return lista1;
    }

}

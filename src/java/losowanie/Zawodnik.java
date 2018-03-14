package losowanie;

import java.util.Random;

public class Zawodnik {

    public String name;
    public int kondycja;
    public int technika;
    public int taktyka;
    public int forma;
    public double ranking;

    public Zawodnik(String name, int kondycja, int technika, int taktyka, int forma) {
        this.name = name;
        this.kondycja = kondycja;
        this.technika = technika;
        this.taktyka = taktyka;
        this.forma = forma;

        Random randomGenerator = new Random();
        double liczba = randomGenerator.nextDouble();
        //double liczba2 = 0.8 + 0.1 * forma;

        double wspoczynnik = (100 + (100 * liczba) / 8);
        this.ranking = (kondycja + technika + taktyka) * wspoczynnik;

        //System.out.println("forma " + forma + " " + " wspoczynnik " +  wspoczynnik + " " + name + " liczba2 " + liczba2 + " " + this.ranking);
    }

}

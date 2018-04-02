<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="losowanie.Zawodnik"%>
<%@page import="losowanie.Algorytm"%>
<%@page import="java.sql.*"%>
<% Class.forName("com.mysql.jdbc.Driver");%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Losowanie</title>
        <style type="text/css">
            .tg  {border-collapse:collapse;border-spacing:0;border-color:#aaa;}
            .tg td{font-family:Arial, sans-serif;font-size:55px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:#aaa;color:#333;background-color:#fff;}
            .tg th{font-family:Arial, sans-serif;font-size:45px;font-weight:normal;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:#aaa;color:#fff;background-color:#f38630;}
            .tg .tg-j2zy{background-color:#FCFBE3;vertical-align:central}
            .tg .tg-2{background-color:blue;vertical-align:central}
            .tg .tg-9hbo{font-weight:bold;vertical-align:top;background-color: orange}
            input[type="text"] {font-size:30px}
        </style>
    </head>
    <body>
        <%!
            public class Druzyna {

                String URL = "jdbc:mysql://dejski.nazwa.pl:3306/sakila";
                String USERNAME = "root";
//                String PASSWORD = "admin";
//                String URL = "jdbc:mysql://localhost:3306/pilkajav_sakila";
//                String USERNAME = "pilkajav_root";
                String PASSWORD = "dejski121!@#";
                Connection connection = null;
                PreparedStatement selectActors = null;
                PreparedStatement selectDoGry = null;
                ResultSet resultSet = null;

                public Druzyna() {
                    try {
                        connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
                        selectActors = connection.prepareStatement("SELECT name,kondycja,technika, taktyka, forma, obecny FROM zawodnicy");
                        selectDoGry = connection.prepareStatement("SELECT name,kondycja,technika, taktyka, forma, obecny FROM zawodnicy WHERE obecny=1");
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }

                public ResultSet getZawodnikow() {
                    try {
                        resultSet = selectActors.executeQuery();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    return resultSet;
                }

                public ResultSet getZawodnikowDoGry() {
                    try {
                        resultSet = selectDoGry.executeQuery();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    return resultSet;
                }

                public String getObrazek(String kto) {
                    if (kto.equals("Bogdan") || kto.equals("Dejski") || kto.equals("Piotr") || kto.equals("Leszek") || kto.equals("Kajtek") || kto.equals("Marcin")
                            || kto.equals("_Dlugi") || kto.equals("Jurek") || kto.equals("_Tomek_R") || kto.equals("Andrzej") || kto.equals("Lukasz")
                            || kto.equals("Andrzej") || kto.equals("Pawel") || kto.equals("Slawek") || kto.equals("Staszek") || kto.equals("Darek")
                            || kto.equals("Tuniek") || kto.equals("_TomekK") || kto.equals("__GOSC")) {
                        if (kto.equals("Bogdan")) {
                            return "<img src=\"img/" + kto + ".gif\" />";
                        } else {
                            return "<img src=\"img/" + kto + ".jpg\" />";
                        }
                    } else {
                        return kto;
                    }

                }

                public int updateZawodnika(String name, int obecny) {
                    int result = 0;
                    try {
                        PreparedStatement updateZawodnik = null;
                        updateZawodnik = connection.prepareStatement("UPDATE zawodnicy SET obecny = ? WHERE name=?");
                        updateZawodnik.setInt(1, obecny);
                        updateZawodnik.setString(2, name);
                        result = updateZawodnik.executeUpdate();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    return result;
                }
            }
        %>

        <%
            Druzyna druzyna = new Druzyna();
            List<Zawodnik> ekipa = new ArrayList<Zawodnik>();

            //UPDATE PO SUBMIT
            if (request.getParameter("losuj") != null) {
                ResultSet zawodnicy = druzyna.getZawodnikow();
                String chetniDoGry[] = request.getParameterValues("zawodnik");

                while (zawodnicy.next()) {
                    String stringToSearch = zawodnicy.getString("name");
                    boolean found = false;
                    for (String element : chetniDoGry) {
                        if (element.equals(stringToSearch)) {
                            found = true;
                        }
                    }
                    if (found) {
                        //System.out.println("The array contains the string: " + stringToSearch);
                        druzyna.updateZawodnika(zawodnicy.getString("name"), 1);
                    } else {
                        //System.out.println("The array does not contains the string: " + stringToSearch);
                        druzyna.updateZawodnika(zawodnicy.getString("name"), 0);
                    }
                    //System.out.println(zawodnicy.getString("forma"));
                }

                //POBRANIE TYCH DO GRY
                ResultSet doGry = druzyna.getZawodnikowDoGry();
                while (doGry.next()) {
                    Zawodnik zawodnik = new Zawodnik(doGry.getString("name"), doGry.getInt("kondycja"), doGry.getInt("technika"), doGry.getInt("taktyka"), doGry.getInt("forma"));
                    ekipa.add(zawodnik);
                    //System.out.println("####" + ekipa.size());
                }

                Algorytm alg = new Algorytm();
                List wynik = alg.losuj(ekipa);

                List<String> zespol1 = (List<String>) wynik.get(0);
                List<String> zespol2 = (List<String>) wynik.get(1);
                List<String> sumy = (List<String>) wynik.get(2);
//                System.out.println(sumy.get(0));
//                System.out.println(sumy.get(1));

        %>
        <table class="tg">
            <tbody>
                <!--<tr>                    <th class="tg-9hbo" colspan="2">Różnica: <%=sumy.get(2)%></th>                </tr>-->
                <tr>
                    <th class="tg-9hbo">&nbsp;&nbsp;&nbsp;Patałachy (<%=sumy.get(0)%>)&nbsp;&nbsp;&nbsp;</th>
                    <th class="tg-2">&nbsp;&nbsp;&nbsp;Łamagi (<%=sumy.get(1)%>)&nbsp;&nbsp;&nbsp;</th>
                </tr>
                <tr>
                    <td class="tg-9hbo"><%
                        for (Iterator<String> iterator = zespol1.iterator(); iterator.hasNext();) {
                            String next = iterator.next();
                        %><%= druzyna.getObrazek(next)%><%
                            }
                        %></td>
                    <td class="tg-2"><%
                        for (Iterator<String> iterator = zespol2.iterator(); iterator.hasNext();) {
                            String next = iterator.next();
                        %><%= druzyna.getObrazek(next)%><%
                            }
                        %></td>
                </tr>
            </tbody>
        </table>
        <br>

        <%
            }//KONIEC PO SUBMIT

            //POBRANIE STANU JU PO EWENTUALNYM UPDATE
            ResultSet zawodnicy = druzyna.getZawodnikow();

        %>

        <form name="myForm" action="index.jsp" method="POST">
            <p></p>
            <table border="0"  class="tg">
                <tbody>
                    <tr><td colspan="4" style="text-align:center;"><input type="submit" value="      Losuj!      " name="losuj" style="font-size:50px;font-weight: bold;background-color: #f38630;height: 150px" /><br></td></tr>
                            <%                    int liczniTAB = 0;
                                while (zawodnicy.next()) {
                                    liczniTAB++;
                                    if (liczniTAB % 2 == 0) {
                            %>
                <td class="tg-j2zy"><%= druzyna.getObrazek(zawodnicy.getString("name"))%></td>
                <td> <input type="checkbox" style="width: 70px;height: 70px;" name="zawodnik" value=<%= zawodnicy.getString("name")%>
                            <% if (zawodnicy.getInt("obecny") == 1) {
                            %>checked<%}%> ></td></tr>
                    <%
                    } else {
                    %>
                <tr><td class="tg-j2zy"><%= druzyna.getObrazek(zawodnicy.getString("name"))%></td>
                    <td> <input type="checkbox" style="width: 70px;height: 70px;" name="zawodnik" value=<%= zawodnicy.getString("name")%> 
                                <% if (zawodnicy.getInt("obecny") == 1) {
                                %>checked<%}%> ></td>
                        <%}%>
                        <%}%>
                    </tbody>
            </table>
        </form>
    </body>
</html>

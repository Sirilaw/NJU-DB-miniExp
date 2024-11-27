import java.sql.*;
import java.util.Scanner;

public class sql_lab {
    static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    static final String DB_URL = "jdbc:mysql://127.0.0.1:3306/orderdb?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    static final String USER = "root";
    static final String PASS = "lsy422!!";

    public static void main(String[] args) {
        Connection conn = null;
        Statement stmt = null;
        try {
            Class.forName(JDBC_DRIVER);
            conn = DriverManager.getConnection(DB_URL, USER, PASS);
            stmt = conn.createStatement();
            System.out.println("Connection Succeeds");
            /*begin Q4.1*/
            String sql4_1 = "select employeeNo, employeeName, salary from employee order by salary desc limit 20";
            ResultSet resultSet = stmt.executeQuery(sql4_1);
            System.out.println("employeeNo\temployeeName\tsalary");
            while (resultSet.next()) {
                String employeeNo = resultSet.getString("employeeNo");
                String employeeName = resultSet.getString("employeeName");
                double salary = resultSet.getDouble("salary");
                System.out.println(employeeNo + "\t" + employeeName + "\t" + salary);
            }
            /*end Q4.1*/

            /*begin Q4.2*/
            String sql4_2 = "insert Customer values('C20080002', '泰康股份有限公司', '010-5422685', '天津市', '220501')";
            int res = stmt.executeUpdate(sql4_2);
            if (res >= 1) {
                System.out.println("Customer inserted");
            } else {
                System.out.println("Customer not inserted");
            }
            /*end Q4.2*/

            /*begin Q4.3*/
            String sql4_3 = "delete from employee where salary > 5000;";
            stmt.executeUpdate(sql4_3);
            /*end Q4.3*/

            /*begin Q4.4*/
            String sql4_4 = "update product set productPrice = 0.5 * productPrice where productPrice > 1000;";
            stmt.executeUpdate(sql4_4);
            /*end Q4.4*/

            /*begin Q5.1*/
            System.out.println("Input department: ");
            Scanner sc = new Scanner(System.in);
            String input = sc.next();
            PreparedStatement pstmt = conn.prepareStatement("update employee set salary = salary + 200 where department = (?);");
            pstmt.setString(1, input);
            if (pstmt.executeUpdate() >= 1) {
                System.out.println("Department updated");
            }else {
                System.out.println("Department not updated");
            }
//            /*end Q5.1*/
//
            /*begin Q5.2*/
            String sql5_2 = "select customerName, address, telephone from customer;";
            PreparedStatement pstmt = conn.prepareStatement(sql5_2, ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
            pstmt.setFetchSize(Integer.MIN_VALUE);
            pstmt.setFetchDirection(ResultSet.FETCH_REVERSE);
            ResultSet rs = pstmt.executeQuery();
            System.out.println("customerName\taddress\ttelephone");
            while (rs.next()) {
                String customerName = rs.getString("customerName");
                String address = rs.getString("address");
                String telephone = rs.getString("telephone");
                System.out.println(customerName + "\t" + address + "\t" + telephone);
            }
            /*end Q5.2*/
            conn.close();
        } catch (SQLException se) {
            se.printStackTrace();
        } catch (ClassNotFoundException cnfe) {
            cnfe.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try{
                if (stmt != null) stmt.close();
            } catch (SQLException se2) {}
            try {
                if (conn != null) conn.close();
            } catch (SQLException se) {
                se.printStackTrace();
            }
        }
        System.out.println("Goodbye!");
    }
}
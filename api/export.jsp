<%@page contentType="text/csv;charset=MS950" pageEncoding="UTF-8" import="java.sql.*, java.io.*, java.net.URLEncoder" %>
<%
response.setHeader("Access-Control-Allow-Origin", "*");
response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
response.setHeader("Access-Control-Allow-Headers", "Content-Type");
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");
response.setContentType("text/csv; charset=MS950");

String filename = "HB.csv";
response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

String startDate = request.getParameter("startDate");
String endDate = request.getParameter("endDate");

Connection conn = null;
PreparedStatement stmt = null;
ResultSet rs = null;

try {
    Class.forName("oracle.jdbc.OracleDriver");
    javax.naming.Context ctx = new javax.naming.InitialContext();
    javax.sql.DataSource ds = (javax.sql.DataSource) ctx.lookup("java:comp/env/jdbc/oracle_HBWEBT");
    conn = ds.getConnection();
    conn.setAutoCommit(true);

    String sql = "YourSQL such as select * from balabala";

    stmt = conn.prepareStatement(sql);
    stmt.setString(1, startDate);
    stmt.setString(2, endDate);
    rs = stmt.executeQuery();

    java.sql.ResultSetMetaData meta = rs.getMetaData();
    int colCount = meta.getColumnCount();

    // 標題列
    for (int i = 1; i <= colCount; i++) {
        out.print(convert(meta.getColumnLabel(i)));
        if (i < colCount) out.print(",");
    }
    out.print("\r\n");

    // 資料列
    while (rs.next()) {
        for (int i = 1; i <= colCount; i++) {
            String value = convert(rs.getString(i));
            if (value != null && value.matches("^0\\d+$")) {
                value = "=\"" + value + "\"";
            }
            out.print(value != null ? value.replace(",", "，") : "");
            if (i < colCount) out.print(",");
        }
        out.print("\r\n");
    }

    rs.close();
    stmt.close();
    conn.close();
} catch (Exception e) {
    out.println("錯誤：" + e.getMessage());
}


%>
<%! // 字碼轉換
private String convert(String input) {
    if (input == null) return "";
    byte[] iso = input.getBytes(java.nio.charset.StandardCharsets.ISO_8859_1);
    return new String(iso, java.nio.charset.Charset.forName("MS950"));
}
%>

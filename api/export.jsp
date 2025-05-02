<%@page contentType="text/csv;charset=MS950" pageEncoding="UTF-8" import="java.sql.*, java.io.*, java.net.URLEncoder" %>

<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.NamingException" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="java.nio.charset.Charset" %>
<%@ page import="java.nio.charset.StandardCharsets" %>

<%
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");
	response.setContentType("application/json");
%>

<%!String convertiso88591ToMS950(String input){
	//經過測試要先將資料庫的字碼以StandardCharsets.ISO_8859_1轉出就會轉出為MS950的字碼
	if(input==null){
		return("");
	}else{
		byte[] iso88591Bytes = input.getBytes(StandardCharsets.ISO_8859_1);
		String ms950String = new String(iso88591Bytes,Charset.forName("MS950"));
		return(ms950String);
	}
	
}
%>

<%!String IFNULL(String input1,String input2){
      if(input1==null){
          return(input2);
      }else{
          return(input1);
      } 
  }
 %>

<%
	String startDate = request.getParameter("startDate");
	String endDate = request.getParameter("endDate");

	//==============連線資料庫====================
	//驅動路徑
   	final String DBDRIVER = "oracle.jdbc.OracleDriver";
   	//資料庫連線
   	Connection conn = null;
	PreparedStatement stmt = null;
	String sql = "";
	ResultSet rs = null;

try {
	//加載驅動
	            Class.forName(DBDRIVER);
	            Context ctx=new InitialContext();
		      	DataSource ds=(DataSource)ctx.lookup("java:comp/env/jdbc/oracle");
	            //連線資料庫
	            conn=ds.getConnection();
	            conn.setAutoCommit(true);
		      	//out.println("Opened database successfully");
				
	sql = "";

    stmt = conn.prepareStatement(sql);
    stmt.setString(1, startDate);
    stmt.setString(2, endDate);
    rs = stmt.executeQuery();

    ResultSetMetaData meta = rs.getMetaData();
    int colCount = meta.getColumnCount();

    // 寫入標題
	for (int i = 1; i <= colCount; i++) {
		out.print(convertiso88591ToMS950(meta.getColumnLabel(i)));
		if (i < colCount) out.print(",");
	}
	out.println();

	// 寫入資料
	while (rs.next()) {
		for (int i = 1; i <= colCount; i++) {
			String raw = rs.getString(i);
			String value = convertiso88591ToMS950(raw);
			out.print(value != null ? value.replace(",", "，") : "");
			if (i < colCount) out.print(",");
		}
		out.println();
	}

    rs.close();
    stmt.close();
    conn.close();
} catch (Exception e) {
    out.println("發生錯誤：" + e.getMessage());
}
%>

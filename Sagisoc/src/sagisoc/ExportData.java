package sagisoc;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.util.Iterator;

import com.google.gdata.util.AuthenticationException;
import com.google.gdata.util.ServiceException;

public class ExportData extends HttpServlet {
	private static final long serialVersionUID = -296698971282506430L;
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		PrintWriter out = resp.getWriter();
        
        //check if the user provided a 'video' parameter
		String videoid=req.getParameter("videoid");
		String videoname=req.getParameter("video");
		if(videoid==null) {
			resp.setStatus(400); //Bad request
			out.println("You must specify a video id!");
			return;
		}		
		
		resp.setContentType("text/plain");
		resp.setHeader("Content-Disposition", "attachment;filename=\""+videoname+"-data.csv\"");

		try{
			
			FusionApi table=new FusionApi();
			table.run("SELECT TesterId, Time, TransactionId, TransactionTime, Transaction, JumpTime FROM " +  FusionApi.DOWNLOAD_DATA + " WHERE VideoId='" + req.getParameter("videoid") + "'");
			
			out.println("TesterId,Time,TransactionId,TransactionTime,Transaction, JumpTime");
			
			for (Iterator<String[]> rows = table.getRowsIterator(); rows.hasNext(); ) { 
				String[] rowValues = rows.next();
				
				out.print(rowValues[0] + ",");
				out.print(rowValues[1] + ",");
				out.print(rowValues[2] + ",");
				out.print(rowValues[3] + ",");
				out.print(rowValues[4] + ",");
				out.println(rowValues[5]);
			}
		} catch (AuthenticationException e) {
    		resp.sendRedirect("/autherror.html");
    	} catch (ServiceException e) {
    		resp.sendRedirect("/fusionerror.html");
    	} catch (Exception e) {
    		resp.sendRedirect("/wrong.jsp");
    	}	
	}

}




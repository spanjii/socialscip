/**
 * 
 * @author Kostas Pardalis
 */

package sagisoc;

import java.util.Iterator;
import com.google.gdata.util.AuthenticationException;
import com.google.gdata.util.ServiceException;
import java.io.IOException;
import java.net.SocketTimeoutException;

import javax.servlet.http.*;

import sagisoc.FusionApi;

public class NewRequests extends HttpServlet {
	private static final long serialVersionUID = -296698971282506430L;

	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws IOException, SocketTimeoutException {
		String action = req.getParameter("action");
		
			try {
				
				if (action.equals("Accept")) {
					FusionApi tables = new FusionApi();
					String query = "INSERT INTO " + FusionApi.RESEARCHERS
							+ " (Mail, Name) VALUES ('"
							+ req.getParameter("mail") + "', '"
							+ req.getParameter("name") + "')";
					tables.run(query);
					
					query = "DELETE FROM " + FusionApi.REQUESTS + " WHERE ROWID='" +
	    					req.getParameter("rowid") + "'";
	    			tables.run(query);
	    		} else if (action.equals("Delete")) { 
	    			FusionApi tables = new FusionApi();
	    			String query = "DELETE FROM " + FusionApi.REQUESTS + " WHERE ROWID='" +
	    					req.getParameter("rowid") + "'";
	    			tables.run(query);
	    		} else if (action.equals("Cancel")) { 
	    			FusionApi tables = new FusionApi();
	    			String query = "DELETE FROM " + FusionApi.REQUESTS + " WHERE ROWID='" +
	    					req.getParameter("rowid") + "'";
	    			tables.run(query);
	    		} else if (action.equals("Remove")) { 
	    			FusionApi tables = new FusionApi();
	    			FusionApi tables2 = new FusionApi();
	    			FusionApi tables3 = new FusionApi();
	    			tables2.run("SELECT ROWID FROM " + FusionApi.RESEARCHERS + " WHERE Mail='" + req.getParameter("mail") + "'");
	    			Iterator<String[]> rows = tables2.getRowsIterator();
					String[] rowValues = rows.next();
	    			String query = "DELETE FROM " + FusionApi.RESEARCHERS + " WHERE ROWID='" +
	    					rowValues[0] + "'";
	    			tables.run(query);
	    			
	    			query = "DELETE FROM " + FusionApi.REQUESTS + " WHERE ROWID='" +
	    					req.getParameter("rowid") + "'";
	    			tables.run(query);
	    			
	    			tables3.run("SELECT ROWID FROM " + FusionApi.EXPERIMENTS + " WHERE ResearcherId='" + rowValues[0] + "'");
	    			for (Iterator<String[]> rows1 = tables3.getRowsIterator(); rows1
							.hasNext();) {
	    				String[] rowValues1 = rows1.next();
	    				query = "DELETE FROM " + FusionApi.EXPERIMENTS + " WHERE ROWID='" +
	    						rowValues1[0] + "'";
	    				tables.run(query);
	    			}
	    		}

			} catch (AuthenticationException e) {
				resp.sendRedirect("/autherror.html");
			} catch (ServiceException e) {
				resp.sendRedirect("/fusionerror.html");
			} catch (Exception e) {
				resp.sendRedirect("/wrong.jsp");
			}
			resp.sendRedirect("/welcome");
		}
}
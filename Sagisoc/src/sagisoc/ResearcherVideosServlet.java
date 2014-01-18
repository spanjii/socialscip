package sagisoc;

import com.google.gdata.util.AuthenticationException;
import com.google.gdata.util.ServiceException;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.SocketTimeoutException;

import javax.servlet.http.*;

import sagisoc.FusionApi;

/* This servlet is executed in response to a Researchers action of Inserting,
 * Updating or Deleting an experiment from his list of active ones.
 */
public class ResearcherVideosServlet extends HttpServlet {
	private static final long serialVersionUID = -296698971282506430L;
	
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws IOException, SocketTimeoutException {
		int action = Integer.parseInt(req.getParameter("action")); // Kind of action requested from user
		PrintWriter out = resp.getWriter();
		String result = "OK";

    	try {
    		FusionApi tables = new FusionApi();
    		if (action == 1) { // Update experiment info
    			String query = "UPDATE " + FusionApi.EXPERIMENTS + " SET VideoURL='" + 
    					req.getParameter("videourl") + "', VideoDescr='" +
    					req.getParameter("descr") + "', Controls='" +
    					req.getParameter("controls") + "', Questionarie='" +
    					req.getParameter("question") + "', Info='" +
    					req.getParameter("info") + "' WHERE ROWID='" +
    					req.getParameter("expid") + "'";
    			tables.run(query);
    		} else if (action == 2) { // Create new experiment
    			String query = "INSERT INTO " + FusionApi.EXPERIMENTS + " (ResearcherId, VideoURL, " +
    					"VideoDescr, Controls, Questionarie, Info) VALUES ('" +
    					req.getParameter("researcher") + "', '" +
    					req.getParameter("videourl") + "', '" +
    					req.getParameter("descr") + "', '" +
    					req.getParameter("controls") + "', '" +
    					req.getParameter("question") + "', '" +
    					req.getParameter("info") + "')";
    			tables.run(query);
    			result = tables.getFirstRow()[0];
    		} else if (action == 3) { // Delete experiment
    			String query = "DELETE FROM " + FusionApi.EXPERIMENTS + " WHERE ROWID='" +
    					req.getParameter("expid") + "'";
    			tables.run(query);
    		}
	    } catch (AuthenticationException e) {
	    	result = "ERROR";
	    } catch (ServiceException e) {
	    	result = "ERROR";
	    }
    	out.print(result);
	}
}
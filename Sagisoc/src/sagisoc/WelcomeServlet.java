package sagisoc;

import com.google.appengine.api.users.User;

import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.google.gdata.util.AuthenticationException;
import com.google.gdata.util.ServiceException;
import java.util.Iterator;
import java.io.IOException;
import java.net.URLEncoder;
import javax.servlet.http.*;

import sagisoc.FusionApi;

import javax.servlet.ServletException;

/* This is the main servlet of the application. All incoming traffic comes here
 *  where the servlet decides the appropriate response.*/
public class WelcomeServlet extends HttpServlet {
	private static final long serialVersionUID = -296698971282506430L;
	private String[] record;
	private String[] columns;

	/* This method determines if the user belongs to the researchers group. */
	private boolean isResearcher(User user)
			throws AuthenticationException, ServiceException, IOException, ServletException {
    	FusionApi tables = new FusionApi();
	 	String userMail = user.getEmail();
		boolean found = false;
		
		// Check Researchers table to see if user is there
	 	tables.run("SELECT ROWID, Mail FROM " + FusionApi.RESEARCHERS);
	 	for (Iterator<String[]> rows = tables.getRowsIterator(); rows.hasNext(); ) {
		 	String[] rowValues = rows.next();
		 	if (rowValues[1].equals(userMail)) {
		 		record = rowValues;
		 		found = true;
		 		break;
		 	}
		}
	 	
	 	return found;
	}
	
	/* This method searches the Experiments table to collect the info for
	 * the requested video.
	 */
	private boolean videoInfo(String videoId)
			throws AuthenticationException, ServiceException, IOException, ServletException {
    	FusionApi tables = new FusionApi();
		
	 	tables.run("SELECT * FROM " + FusionApi.EXPERIMENTS + " WHERE ROWID='"
	 			+ videoId + "'");
	 	if (tables.rowCount() != 0) {
	 		record = tables.getFirstRow();
	 		columns = tables.getColumnNames();
	 		return true;
	 	} else
	 		return false;
	}
	
	/* An utility method used to construct the URL to watch the
	 * requested video.
	 */
	private String watchURL(String videoId) {
		StringBuffer url= new StringBuffer("/watch.jsp?videoId=" + videoId);
		
		for (int i = 1; i < record.length; i++) {
			if (!record[i].isEmpty())
				url.append("&" + columns[i] + "=" + record[i]);
		}
		return url.toString();
	}

	
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException, ServletException {
		UserService userService = UserServiceFactory.getUserService();
	    User user = userService.getCurrentUser();
	    String videoId = req.getParameter("videoId");

		if (user == null) {
			try {
				if (videoId != null) { // To watch video
					if (videoInfo(videoId)) { // Video found
						resp.sendRedirect(watchURL(videoId));
					} else {
						// Video does not exists
						resp.sendRedirect("/videoerror.html");
					}
				} else {
						String login = userService.createLoginURL(req.getRequestURI());
						String logout = userService.createLogoutURL(req.getRequestURI());
						resp.sendRedirect("/login.jsp?login="
								+ URLEncoder.encode(login, "UTF-8")
								+ "&logout="
								+ URLEncoder.encode(logout, "UTF-8"));
				}
			} catch (AuthenticationException e) {
				resp.sendRedirect("/autherror.html");
			} catch (ServiceException e) {
				resp.sendRedirect("/fusionerror.html");
			} catch (Exception e) {
				resp.sendRedirect("/wrong.jsp");
			}
		} else {
			try {
				if (videoId != null) { // To watch video
					if (videoInfo(videoId)) { // Video found
						resp.sendRedirect(watchURL(videoId));
					} else {
						// Video does not exists
						resp.sendRedirect("/videoerror.html");
					}
				}
				if (isResearcher(user)) { // Yes
					String logout = userService.createLogoutURL(req
							.getRequestURI());
					resp.sendRedirect("/researcherpanel.jsp?userid="
							+ record[0] + "&logout="
							+ URLEncoder.encode(logout, "UTF-8"));
				} else {
					if (UserInfo.isAdministrator()) { // Yes
						String logout = userService.createLogoutURL(req.getRequestURI());
						resp.sendRedirect("/firstsigninadmin.jsp?logout=" + URLEncoder.encode(logout, "UTF-8"));
					} else{
						String logout = userService.createLogoutURL(req.getRequestURI());
						resp.sendRedirect("/guests.jsp?logout=" + URLEncoder.encode(logout, "UTF-8"));
					}
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
}
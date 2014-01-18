/**
 * 
 * @author Kostas Pardalis
 */

package sagisoc;

import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.google.gdata.util.AuthenticationException;
import com.google.gdata.util.ServiceException;
import java.io.IOException;
import java.net.SocketTimeoutException;
import java.net.URLEncoder;
import java.util.Iterator;

import javax.servlet.http.*;

import sagisoc.FusionApi;

public class SignInAdmin extends HttpServlet {
	private static final long serialVersionUID = -296698971282506430L;

	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws IOException, SocketTimeoutException {
		UserService userService = UserServiceFactory.getUserService();
		String logout = userService.createLogoutURL(req.getRequestURI());
		String name = req.getParameter("name");
		String mail = req.getParameter("mail");		
		
		if (name.length() < 3) {
			resp.sendRedirect("/firstsigninadmin.jsp?logout="
					+ URLEncoder.encode(logout, "UTF-8") + "&hasname=false");
		} else {

			try {
				boolean doRequest = false;
				FusionApi tables1 = new FusionApi();
				tables1.run("SELECT Mail FROM " + FusionApi.RESEARCHERS);
				for (Iterator<String[]> rows1 = tables1.getRowsIterator(); rows1
						.hasNext();) {
					String[] rowValues = rows1.next();

					if (mail.equals(rowValues[0])) {
						doRequest = true;
					}
				}
				if (doRequest == false) {
					FusionApi tables = new FusionApi();
					String query = "INSERT INTO " + FusionApi.RESEARCHERS
							+ " (Mail, Name) VALUES ('"
							+ req.getParameter("mail") + "', '"
							+ req.getParameter("name") + "')";
					tables.run(query);
				}
				else {
					resp.sendRedirect("/welcome");
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
}
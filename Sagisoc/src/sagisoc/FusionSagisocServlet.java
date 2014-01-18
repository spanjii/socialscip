package sagisoc;

import com.google.gdata.util.AuthenticationException;

import com.google.gdata.util.ServiceException;

import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.text.SimpleDateFormat;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.*;

import sagisoc.FusionApi;

/**
 * This servlet is responsible for collecting the interactions on the watched
 * video, preparing a record for each one and sending them for insertion at
 * Fusion Table Service.
 * 
 */
public class FusionSagisocServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = -296698971282506430L;

	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws IOException, ServletException {
		PrintWriter out = resp.getWriter();
		String result = "OK";
		if (req.getParameter("text1") != null) {
			// UserService userService = UserServiceFactory.getUserService();
			// String user = userService.getCurrentUser().getEmail(); // Get
			// users email
			Pattern p = Pattern.compile("\\s*(\\d{1})\\s+(\\d+)\\s+([\\-\\+]?\\d+)\\s+(\\d+)"); // Regex for the interactions
			Matcher m = p.matcher(req.getParameter("text1")); // The interactions are here
			String videoId = req.getParameter("videoId"); // and this is the videoId

			String testerId = req.getParameter("testerId");
			if (testerId == null) {
				testerId = "999";
			}
			SimpleDateFormat d = new SimpleDateFormat("dd/MM/yyyy KK:MM:ss");
			StringBuffer s = new StringBuffer();
			int i = 0;

			while (m.find()) { // Iterate over all interactions
				i++;
				s.append("INSERT INTO "
						+ FusionApi.DATA
						+ " (VideoId, TesterId, TransactionId, Time, JumpTime, "
						+ "TransactionTime) VALUES ('" + videoId + "', '"
						+ testerId + "', "); // One record for each interaction
				s.append(m.group(1) + ", "); // TransactionId from Regex
				s.append(m.group(2) + ", "); // Video time from Regex
				s.append(m.group(3) + ", "); // jump time from Regex
				s.append("'" + d.format(new Date(Long.parseLong(m.group(4))))
						+ "');"); // TransactionTime from Regex
			}
			if (i == 1) // For only one record delete record separator ';'
				s.deleteCharAt(s.length() - 1);

			try {
				FusionApi tables = new FusionApi();
				tables.run(s.toString()); // Send request to Fusion Table Service
			} catch (AuthenticationException e) { // Couldn't connect to service
				result = "ERROR";
			} catch (ServiceException e) { // Couldn't execute query
				result = "ERROR";
			} catch (Exception e) {
				result = "ERROR";
			}

		}
		out.print(result);
	}
}
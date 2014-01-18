package sagisoc;

import java.io.IOException;


import java.util.Iterator;

import javax.servlet.ServletException;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.google.gdata.util.AuthenticationException;
import com.google.gdata.util.ServiceException;


public class UserInfo {

    private static UserService userService = UserServiceFactory.getUserService();

    public static String getMail() {
        User user = userService.getCurrentUser();
        if(user==null) {return "";}
        else {return user.getEmail();}
    }
    
    public static boolean isAdministrator() {
    	return userService.isUserAdmin();    	
    }
    
	public static boolean isResearcher(String mail)
			throws AuthenticationException, ServiceException, IOException, ServletException {
    	FusionApi tables = new FusionApi();
		boolean found = false;
		
		// Check Researchers table to see if user is there
	 	tables.run("SELECT ROWID, Mail FROM " + FusionApi.RESEARCHERS);
	 	for (Iterator<String[]> rows = tables.getRowsIterator(); rows.hasNext(); ) {
		 	String[] rowValues = rows.next();
		 	if (rowValues[1].equals(mail)) {
		 		found = true;
		 		break;
		 	}
		}
	 	
	 	return found;
	}
    
    public static String getNickname() {
        User user = userService.getCurrentUser();
        if(user==null) {return "";}
        else {return user.getNickname();}
    }
    
}

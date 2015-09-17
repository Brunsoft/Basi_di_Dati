/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package univr.bdd.piscine.filters;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"*.jsf"})
public class AuthFilter implements Filter {

    public AuthFilter() {
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        try {

            // check whether session variable is set
            HttpServletRequest req = (HttpServletRequest) request;
            HttpServletResponse res = (HttpServletResponse) response;
            res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
            res.setHeader("Pragma", "no-cache"); // HTTP 1.0.
            res.setDateHeader("Expires", 0); // Proxies.
            HttpSession ses = req.getSession(false);
            //  allow user to proccede if url is index.jsf or user logged in or user is accessing any page in //public folder
           
			String reqURI = req.getRequestURI();
            if (reqURI.indexOf("/index.jsf") >= 0 ||
					reqURI.indexOf("/impianto.jsf") >= 0 || 
					(ses != null && ses.getAttribute("username") != null) || 
					reqURI.indexOf("/public/") >= 0 || 
					reqURI.contains("javax.faces.resource")) {
                chain.doFilter(request, response);
            } else // user didn't log in but asking for a page that is not allowed so take user to index page
            {
                res.sendRedirect(req.getContextPath() + "/index.jsf");  // Anonymous user. Redirect to index page
            }
        } catch (Throwable t) {
            System.out.println(t.getMessage());
        }
    } //doFilter

    @Override
    public void destroy() {
    }
}

package com.emva.newsapp.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;
import javax.validation.Valid;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.TransactionSystemException;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.emva.newsapp.model.Comment;
import com.emva.newsapp.model.Image;
import com.emva.newsapp.model.News;
import com.emva.newsapp.model.NewsImageHead;
import com.emva.newsapp.model.User;
import com.emva.newsapp.model.UserProfile;
import com.emva.newsapp.model.UserProfileType;
import com.emva.newsapp.service.CommentService;
import com.emva.newsapp.service.ImageService;
import com.emva.newsapp.service.NewsService;
import com.emva.newsapp.service.UserAuthenticationUtilService;
import com.emva.newsapp.service.UserProfileService;
import com.emva.newsapp.service.UserService;

@Controller
@RequestMapping("/")
public class NewsAppController {
    
    private Logger LOG = LoggerFactory.getLogger(NewsAppController.class);
    
    @Autowired
    private NewsService newsService;
    
    @Autowired
    private Properties newsProperties;
    
    @Autowired
    @Qualifier("commentService")
    private CommentService commentService;
    
    @Autowired
    private ImageService imageService;
    
    @Autowired 
    private UserService userService;
    
    @Autowired
    private UserAuthenticationUtilService userAuthenticationUtilService;
    
    @Autowired
    @Qualifier("userProfileService")
    private UserProfileService userProfileService;
    
    @RequestMapping(value = {"/", "/home", "/home2"})
    public String home(Model model) {
        model.addAttribute("test", "Hello World!");
        model.addAttribute("greeting", "Welcome to this site");
        model.addAttribute("user", userAuthenticationUtilService.getPrincipal());
        return "home.jsp";
    }
    
    @RequestMapping(value = "/thymeleaf")
    public String thymeleaf(Model model) {
        model.addAttribute("test", "Hello World!");
        model.addAttribute("greeting", "Welcome To this site");
        
        return "home";
    }
    
    /* ==== Test Routes ==== */
    
    @RequestMapping(value = "/test", method = RequestMethod.GET)
    public String test(Model model) {
        System.out.println("GET Request to /test");
        Comment comment = new Comment();
        comment.setText("bla bla blah!");
        
        String userName = userAuthenticationUtilService.getPrincipal();
        System.out.println("username: " + userName);
        
        if (userName != null) {
            User user = userService.findUserBySSO(userName);
            
//            if (user != null) {
                comment.setUser(user);
                comment.setNews(newsService.findNewsById(2)); 
                commentService.saveComment(comment);
                System.out.println("Successfully saved comment");
//            } else {
//                System.out.println("Couldn't save comment, no logged in user.");
//            }
        } else { System.out.println("Username is null"); }
        
        return "redirect:/";
    }
    
    /* ==== Authentication Routes ==== */
    
    @RequestMapping(value = "/access-denied", method = { RequestMethod.GET, RequestMethod.POST, RequestMethod.PUT })
    public String accessDeniedPage(Model model) {
        
        model.addAttribute("user", userAuthenticationUtilService.getPrincipal());

        return "access-denied.jsp";
    }
    
    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String loginPage() {
        return "login.jsp";
    }
    
    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public String logoutPage(HttpServletRequest request, HttpServletResponse response) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null) {
            new SecurityContextLogoutHandler().logout(request, response, auth);
        }
        return "redirect:/login?logout";
    }
    
    /* ==== Publisher Routes ==== */
    
    @RequestMapping(value = "/publisher", method = RequestMethod.GET)
    public String publisherPage(Model model) {
        return "publisher.jsp";
    }

    /* ==== Admin Routes ==== */
    @RequestMapping(value = "/admin", method = RequestMethod.GET)
    public String adminPage(Model model) {
        model.addAttribute("user", new User());
        return "admin.jsp";
    }
    
    /* ==== General Post/Put Result Routes ==== */
    
    @RequestMapping(value = "/results")
    public String userResult(Model model, HttpServletRequest request) {
        
        if (!model.containsAttribute("resultsMessage")) {
            model.addAttribute("resultsMessage", "Previous action was completed!");
        }
        
        if (!model.containsAttribute("linkTitle")) {
            model.addAttribute("linkTitle", "Go to homepage");
        }
        
        if (!model.containsAttribute("linkHref")) {
            model.addAttribute("linkHref", "/");
        }
        
        if (!model.containsAttribute("status")) {
            model.addAttribute("status", "info");
        }
        
        model.addAttribute("user", userAuthenticationUtilService.getPrincipal());
        return "results.jsp";
    }
    
    /* ==== User Routes ==== */

    /**
     * Get all users - GET
     */
    @RequestMapping(value = "/users", method = RequestMethod.GET)
    public String getAllUsers() {
        return "redirect:/";
    }
    
    /**
     * New user form - GET
     */
    @RequestMapping(value = "/users/new", method = RequestMethod.GET)
    public String newUser(Model model) {
        LOG.info("GET request sent to: '/users/new'");
        model.addAttribute("actionUrn", "/users");
        model.addAttribute("methodType", "POST");
        model.addAttribute("user", new User());
        return "create-user.jsp";
    }

    /**
     * Post new user - POST
     */
    @RequestMapping(value = "/users", method = { RequestMethod.POST })
    public String postUser(Model model, @ModelAttribute(name = "user") User user, BindingResult bindingResult, 
            RedirectAttributes redirectAttributes) {
        LOG.info("POST request sent to: '/users'");
        boolean isAdmin = userAuthenticationUtilService.getAuthorities().contains("ROLE_ADMIN");
        boolean isSuccess = false;
        
        //Make sure if no profiles are selected that the user as least gets the USER role
        if (user != null) {
            if (user.getUserProfiles().size() == 0) {
                UserProfile profile = userProfileService.findUserProfileByType("USER");
                if (profile != null) {
                    user.getUserProfiles().add(profile);
                }
            }
            try {
                userService.saveUser(user);
                LOG.info("This user was posted: {}", user);
                redirectAttributes.addFlashAttribute("resultsMessage", "Successfully created user: " + user.getSsoId());
                isSuccess = true;
            } catch (ConstraintViolationException e) {
                LOG.error("Failed to create user: DML operation resulted in a violation of a defined integrity constraint");
                redirectAttributes.addFlashAttribute("resultsMessage", 
                        "Failed to create user: DML operation resulted in a violation of a defined integrity constraint");
            } catch (DataIntegrityViolationException e) {
                LOG.error("User was not posted: DataIntegrityViolationException");
                redirectAttributes.addFlashAttribute("resultsMessage", 
                        "Failed to create user: username already exists");                
            } catch (Exception e) {
                LOG.error("This exception occured: {}", e.getClass().getCanonicalName());
                e.printStackTrace();
                redirectAttributes.addFlashAttribute("resultsMessage", "Failed to create user: Unknown error");
            }
            
            redirectAttributes.addFlashAttribute("status", (isSuccess ? "success" : "danger"));
        }
        
        if (isAdmin) {
            return "redirect:/admin?" + (isSuccess ? "success" : "error");
        }
        else {
            return "redirect:/login";
        }
    }
    
    /**
     * Get user by id - GET
     */
    @RequestMapping(value = "/users/{userId}", method = RequestMethod.GET)
    public String getUser(@PathVariable Integer userId) {
        LOG.info("GET request sent to: '/users/{}'", userId);
        return "redirect:/admin";
    }
    
    /**
     * Edit user form - GET
     */
    @RequestMapping(value = "/users/{userId}/edit", method = RequestMethod.GET)
    public String editUser(@PathVariable(name = "userId") Integer userId, Model model) {
        LOG.info("GET request sent to: '/users/{}/edit'", userId);
        User user = userService.findUserById(userId);
        LOG.info("This user was fetched: {}", user);
        
        if (user != null) {
            user.setPassword(null);
            model.addAttribute("actionUrn", "/users/" + userId);
            model.addAttribute("methodType", "PUT");
            model.addAttribute("user", user);
        } else {
            return "redirect:/admin";
        }
        return "user-form.jsp";
    }    

    /**
     * Update user - PUT
     */
    @RequestMapping(value = "/users/{userId}", method = RequestMethod.PUT) 
    public String updateUser(Model model, @PathVariable Integer userId, @ModelAttribute User user, RedirectAttributes redirectAttributes) {
        LOG.info("PUT request sent to: '/users/{}'", userId);
        
        boolean isSuccess = false;
        
        if (user != null) { 
            User userToUpdate = userService.findUserById(user.getId());
            
            if (userToUpdate != null) {
                userToUpdate.setSsoId(user.getSsoId());
                if (StringUtils.hasLength(user.getPassword())) {
                    userToUpdate.setPassword(user.getPassword());
                }
                userToUpdate.setFirstName(user.getFirstName());
                userToUpdate.setLastName(user.getLastName());
                userToUpdate.setEmail(user.getEmail());
                
                for (UserProfile profile : userToUpdate.getUserProfiles()) {
                    LOG.info("Profile: {}", profile.getType());
                    //only ADMIN can update user profiles, this is not checked in service
                    //so checking manually this controller-method
                    if (profile.getType().equalsIgnoreCase(UserProfileType.ADMIN.getUserProfileType())) {
                        userToUpdate.setUserProfiles(user.getUserProfiles());
                        break;
                    }
                }
                
                try {
                    userService.updateUser(userToUpdate);
                    isSuccess = true;
                    LOG.info("This user was updated: {}", userToUpdate);
                } catch (TransactionSystemException ex) {
                    LOG.error("User was not updated: {}", ex.getMessage());
                }
            } 
        }
        
        redirectAttributes.addFlashAttribute("status", (isSuccess ? "success" : "danger"));

        redirectAttributes.addFlashAttribute("resultMessage", (isSuccess) ? 
                "Dear, " + userAuthenticationUtilService.getPrincipal() + ", the account was successfully updated." : 
                "Error - Couldn't update user!");
        
        if (userAuthenticationUtilService.getAuthorities().contains("ROLE_ADMIN")) {
            return "redirect:/admin";
        } 

        return "redirect:/results";
    }
    
    /**
     * Delete user - DELETE
     */
    @RequestMapping(value = "/users/{userId}", method = RequestMethod.DELETE)
    public String deleteUser(@PathVariable Integer userId, RedirectAttributes redirectAttributes) {
        LOG.info("DELETE request sent to: '/users/{}'", userId);
        userService.deleteUser(userId);
        redirectAttributes.addFlashAttribute("status", "success");
        redirectAttributes.addFlashAttribute("resultsMessage", "Successfully delete user!");
        
        if (userAuthenticationUtilService.getAuthorities().contains("ROLE_ADMIN")) {
            return "redirect:/admin";   
        }
        
        return "redirect:/results";
    }
    
    /* === DBA Routes ==== */
    @RequestMapping(value = "/dba", method = RequestMethod.GET)
    public String dbaPage(Model model) {
        return "redirect:/";
    }
    
    /* ==== News routes ==== */
    
    /**
     * List news - GET
     */
    @RequestMapping(value = "/news")
    public String getNews(Model model) {
        //redirect to home '/'
        return "redirect:/";
    }
    
    /**
     * New news form - GET
     */
    @RequestMapping(value = "/news/new", method = RequestMethod.GET)
    public String newNews(Model model) {
        LOG.info("GET request sent to: '/news/new'");
        model.addAttribute("actionUrn", "/news");
        model.addAttribute("previewUrn", "/news/new/preview");
        model.addAttribute("methodType", "POST");
        News news = new News();
        news.setHeadline("headline");news.setLead("a nice lead");news.setBody("Lorem Ispum x100");
        model.addAttribute("news", news);
        return "news-form.jsp";
    }
    
    /**
     * New news - POST
     */
    @RequestMapping(value = "/news", method = RequestMethod.POST)
    public String postNews(Model model, @ModelAttribute(name="news") News news, @RequestParam(name = "submit", required = false) String submit,
            RedirectAttributes redirectAttributes) {
        LOG.info("POST request sent to: '/news");
        LOG.info("Provided news: " + news.toString());
        LOG.info("submit value: " + submit);
        
        if (submit.equalsIgnoreCase("post")) {
            String userName = userAuthenticationUtilService.getPrincipal();
            User author = null;
            if (userName != null) {
                author = userService.findUserBySSO(userName);
                news.setAuthor(author);
            }
            newsService.saveNews(news);
        } else if (submit.equalsIgnoreCase("preview")) {
//            model.addAttribute("news", news);
            redirectAttributes.addFlashAttribute("news", news);
            return "redirect:/news/new/preview";
        }
        
        return "redirect:/";
    }
    
    /**
     * Preview news currently edited but not yet persisted - GET
     */
    @RequestMapping(value = "/news/new/preview", method = RequestMethod.GET)
    public String previewNewNews(Model model, @ModelAttribute(name="news") News news/*, @RequestParam(name = "actionUrn") String actionUrn*/) {
        LOG.info("GET request sent to: '/news/new/preview");
        LOG.info("Provided news: " + news.toString());
        model.addAttribute("actionUrn", "/news");
        model.addAttribute("previewUrn", "/news/new/preview");
        model.addAttribute("methodType", "POST");
        model.addAttribute("news", news);
        model.addAttribute("isPreview", true);
        return "news-form.jsp";
    }

    /**
     * Get news by id - GET
     */
    @RequestMapping(value = "/news/{id}", method = {RequestMethod.GET})
    public String getNews(@PathVariable(name = "id") Integer id, ModelMap model, 
            @RequestParam(value = "commentsOffset", defaultValue = "0") Integer commentsOffset,
            @ModelAttribute(name = "maxCommentsPerPage") Integer maxCommentsPerPage) {
        LOG.info("GET request sent to: '/news/" + id);
        
        News news = newsService.findNewsById(id);
        model.addAttribute("news", news);

        if (news.getComments().size() > maxCommentsPerPage * (commentsOffset + 1)) {
            model.addAttribute("nextCommentsOffset", commentsOffset + 1);
        }
        
        news.setComments(news.getComments(commentsOffset, maxCommentsPerPage));
        return "news.jsp";
    }
    
    /**
     * Edit news form - GET
     */
    @RequestMapping(value = "/news/{id}/edit", method = RequestMethod.GET)
    public String editNews(@PathVariable(name = "id") Integer id, Model model) {
        
        LOG.info("GET request sent to: '/news/" + id + "/edit'");
        News news = newsService.findNewsById(id);
        
        if (news != null) {
            model.addAttribute("news", news);
            model.addAttribute("actionUrn", "/news/" + id);
            model.addAttribute("previewUrn", "/news/new/preview");
            model.addAttribute("methodType", "PUT");
        } else {
            return "redirect:/news/new";
        }
        return "news-form.jsp";
    }

    /**
     * Preview news currently edited and previously persisted - GET
     */
    @RequestMapping(value = "/news/{newsId}/edit/preview", method = RequestMethod.GET)
    public String previewEditNews(Model model, @ModelAttribute(name="news") News news, @PathVariable Integer newsId) {
        LOG.info("GET request sent to: '/news/" + newsId + "edit/preview");
        LOG.info("Provided news: " + (news != null ? news.toString() : "NULL"));
        model.addAttribute("actionUrn", "/news/" + newsId + "");
        model.addAttribute("previewUrn", "/news/" + newsId + "/preview");
        model.addAttribute("methodType", "PUT");
        model.addAttribute("news", news);
        model.addAttribute("isPreview", true);
        return "news-form.jsp";
    }
    
    /**
     * Update news - PUT
     */
    @RequestMapping(value = "/news/{newsId}", method = RequestMethod.PUT)
    public String updateNews(Model model, @PathVariable(name = "newsId") Integer newsId, @ModelAttribute(name = "news") @Valid News news,
            @RequestParam(name = "submit") String submit, RedirectAttributes redirectAttributes) {
        LOG.info("PUT request sent to: '/news/" + newsId + "'");
        LOG.info("Provided news: " + news.toString());
        
        if (submit == null || submit.equalsIgnoreCase("post")) {
            News newsToUpdate = newsService.findNewsById(news.getId());
            if (newsToUpdate != null) {
                newsToUpdate.setModified(new Date(System.currentTimeMillis()));
                newsToUpdate.setHeadline(news.getHeadline());
                newsToUpdate.setLead(news.getLead());
                newsToUpdate.setBody(news.getBody());
                
                newsService.updateNews(newsToUpdate);
            }
            
            return "redirect:/news/" + newsId;
        } else if (submit != null && submit.equalsIgnoreCase("preview")) {
            redirectAttributes.addFlashAttribute("news", news);
            return "redirect:/news/" + news.getId() + "/edit/preview";
        }
        
        return "redirect:/";
    }
    
    /**
     * Delete news by Id - DELETE
     */
    @RequestMapping(value = "/news/{id}", method = RequestMethod.DELETE)
    public String deleteNews(@PathVariable(name = "id") Integer id, Model model) {
        LOG.info("DELETE request sent to: '/news/" + id + "/delete");
        News news = newsService.findNewsById(id);
        if (news != null) {
            newsService.deleteNews(news);
        }
        return "redirect:/news";
    }
    
    /* ==== Comments routes ==== */
    
    /**
     * Read all comments belonging to a newsId
     */
    @RequestMapping(value = "/news/{newsId}/comments", method = RequestMethod.GET)
    public String readComments(Model model, @PathVariable(name = "newsId") Integer newsId, 
            @RequestParam(name = "fromIndex", required = false) Integer fromIndex, RedirectAttributes redirectAttributes) {

        if (fromIndex != null) {
            redirectAttributes.addFlashAttribute("fromIndex", fromIndex);
        }
        
        //redirect to news-article instead
        return "redirect:/news/" + newsId;
    }
    
    /**
     * New comment form - GET
     */
//    @PreAuthorize("hasRole('PUBLISHER')")
    @RequestMapping(value = "/news/{newsId}/comments/new", method = RequestMethod.GET)
    public String newComment(Model model, @PathVariable(name = "newsId") Integer newsId) {
        model.addAttribute("actionUrn", "/news/" + newsId + "/comments");
        model.addAttribute("methodType", "POST");
        model.addAttribute("comment", new Comment());
        
        return "comment-form.jsp";
    }
    
    /**
     * New Comment - POST
     * Handles new comments directly linked to news-article or as a reply
     */
    @RequestMapping(value = "/news/{newsId}/comments", method = RequestMethod.POST)
    public String postComment(Model model, @PathVariable(name = "newsId") Integer newsId, @ModelAttribute(name = "comment") Comment comment,
            @RequestParam(name = "replyId", required = false) Integer replyId) {
        
        LOG.info("POST request sent to: '/news/" + newsId + "/comments', reply id is: " + replyId);
        LOG.info("Provided comment: " + comment.toString());
        
        String userName = userAuthenticationUtilService.getPrincipal();
        
        if (userName != null) {
            comment.setUser(userService.findUserBySSO(userName));
        }
        
        if (replyId == null) {
            comment.setNews(newsService.findNewsById(newsId)); //works
        } else {
            Comment parentComment = commentService.findCommentById(replyId);
            if (parentComment == null || !parentComment.isActive()) {
                return "redirect:/news/" + newsId;
            }
            
        }
        
        commentService.saveComment(comment);
        
        if (replyId != null) {
            return "redirect:/news/" + newsId + "/comments/" + replyId;
        } 
        
        return "redirect:/news/" + newsId;
    }
    
    /**
     * If trying to fetch comment by id, redirect to the newsId that the comment is linked to. - GET
     * @param newsId
     * @return
     */
    @RequestMapping(value = "/news/{newsId}/comments/{commentId}", method = RequestMethod.GET)
    public String getComment(@PathVariable Integer newsId, @PathVariable Integer commentId, Model model,
            @RequestParam(value = "commentsOffset", defaultValue = "0") Integer commentsOffset,
            @ModelAttribute(name = "maxCommentsPerPage") Integer maxCommentsPerPage) {
        Comment comment = commentService.findCommentByIdFetchChildren(commentId);
        
        if ((comment.getChildren().size() + 1) > maxCommentsPerPage * (commentsOffset + 1)) {
            model.addAttribute("nextCommentsOffset", commentsOffset + 1);
        }
        
        comment.setChildren(Comment.slice(commentsOffset, maxCommentsPerPage - 1, comment.getChildren()));
        
        //set replyId to null to allow node.jsp to run recursion correctly
        comment.setReplyId(null); 
        model.addAttribute("comment", Arrays.asList(comment));
        model.addAttribute("news", newsService.findNewsById(newsId));
        
        LOG.info("Amount of comments: {}", comment.countAllComments());
        
        return "comment.jsp";
    }
    
    /**
     * Edit comment form - GET
     */
    @RequestMapping(value = "/news/{newsId}/comments/{commentId}/edit", method = RequestMethod.GET)
    public String editComment(Model model, @PathVariable(name = "newsId") Integer newsId, @PathVariable(name = "commentId") Integer commentId) {
        model.addAttribute("actionUrn", "/news/" + newsId + "/comments/" + commentId + "/update");
        model.addAttribute("newsId", newsId);
        
        LOG.info("GET request sent to: '/news/" + newsId + "/comments/" + commentId + "/edit'");
        Comment comment = commentService.findCommentById(commentId);
        LOG.info("Fetched this comment: " + comment);
        
        if (comment == null || !comment.isActive()) {
            return "redirect:/news/{newsId}";
        }
        
        model.addAttribute("comment", comment);
        model.addAttribute("actionUrn", "/news/" + newsId + "/comments/" + commentId);
        model.addAttribute("methodType", "PUT");
        
        return "comment-form.jsp";
    }
    
    /**
     * Reply comment form - GET
     */
    @RequestMapping(value = "/news/{newsId}/comments/{commentId}/reply", method = RequestMethod.GET)
    public String replyComment(Model model, @PathVariable Integer newsId, @PathVariable Integer commentId) {
        Comment parentComment = commentService.findCommentById(commentId);
        
        if (parentComment == null || !parentComment.isActive()) {
            return "redirect:/news/{newsId}/";
        }
        
        model.addAttribute("comment", new Comment());
        model.addAttribute("actionUrn", "/news/" + newsId + "/comments");
        model.addAttribute("methodType", "POST");
        model.addAttribute("newsId", newsId);
        model.addAttribute("replyId", commentId);
        model.addAttribute("commentToReply", commentService.findCommentById(commentId));
        System.out.println(commentService.findCommentById(commentId));
        
        LOG.info("GET request sent to: '/news/" + newsId + "/comments/" + commentId + "/reply'");
        LOG.info("ReplyId: " + commentId);
        
        return "comment-form.jsp";
    }
    
    /**
     * Update comment - POST (PUT is more appropriate)
     * Proper route is: "/news/{newsId}/comments/{commentId}", with verb: PUT
     */
    @RequestMapping(value = "/news/{newsId}/comments/{commentId}", method = RequestMethod.PUT)
    public String updateComment(Model model, @PathVariable(name = "newsId") Integer newsId, @PathVariable(name = "commentId") Integer commentId,
            @ModelAttribute(name = "comment") @Valid Comment comment) {
        LOG.info("PUT request sent to: '/news/" + newsId + "/comments/" + commentId + "'");
        LOG.info("Provided comment: " + comment.toString());
        
        Comment commentToUpdate = commentService.findCommentById(comment.getId());
        commentToUpdate.setModified(new Date(System.currentTimeMillis()));
        commentToUpdate.setText(comment.getText());
        
        commentService.updateComment(commentToUpdate); 
        return "redirect:/news/" + newsId;
    }
    
    /**
     * Delete comment - DELETE
     */
//    @PreAuthorize("hasRole('PUBLISHER')")
    @RequestMapping(value = "/news/{newsId}/comments/{commentId}", method = { RequestMethod.DELETE })
    public String deleteComment(Model model, @PathVariable(name = "newsId") Integer newsId, @PathVariable(name = "commentId") Integer commentId) {
        LOG.info("DELETE request sent to: '/news/{}/comments/{}'", new Object[] { newsId, commentId});
        Comment comment = commentService.findCommentById(commentId);
        if (comment != null) {
            comment.setActive(false);
            commentService.updateComment(comment);
            LOG.info("Marking comment id: {} as active=0", comment.getId());
        }
        return "redirect:/news/" + newsId;
    }
    
    /* ==== Data Setup ==== */
    
    @ModelAttribute(name = "maxCommentsPerPage")
    public Integer getMaxCommentsPerPage() {
        Integer maxCommentsPerPage = null;
     
        try {
            maxCommentsPerPage = Integer.parseInt(newsProperties.getProperty("news.comments.max_amount", "10"));
        } catch (NumberFormatException e) {
            maxCommentsPerPage = 10;
        }
        
        return maxCommentsPerPage;
    }
    
    @ModelAttribute(name = "roles")
    public List<Object> getUserRoles() {
        List<UserProfile> userProfiles = userProfileService.findAllUserProfiles();
        List<Object> userProfilesObj = new ArrayList<Object>();
        for (UserProfile profile : userProfiles) {
            userProfilesObj.add(profile);
        }
        return userProfilesObj;
    }
    
    @ModelAttribute
    public void fetchAllEntities(Model model) {
//        List<News> allNews = newsService.findAllNewsFullWithComments();
        List<News> allNews = newsService.findNews(5, 0);
        
        for (News news : allNews) {
            if (news.getNewsImageHeads().size() > 0) {
                LOG.info("Printing images for News-headline: {}", news.getHeadline());
            }
            for (NewsImageHead head : news.getNewsImageHeads()) {
                LOG.info("{}, size: {}, thumbnail: {}", head.getImage(), head.getSize(), head.getThumbnail());
            }
        }
        
        
        List<News> allNewsWithoutComments = newsService.findAllNewsSummary();
        List<Comment> allComments = commentService.findAllComments();
        List<Image> allImages = imageService.findAllImages();
        List<User> allUsers = userService.findAllUsers();
        
        model.addAttribute("allNews", allNews);
        model.addAttribute("allNewsWithoutComments", allNewsWithoutComments);
        
        model.addAttribute("allComments", allComments);
        model.addAttribute("allImages", allImages);
        model.addAttribute("allUsers", allUsers);
    }
    
    /* ==== Helper Methods ==== */
}

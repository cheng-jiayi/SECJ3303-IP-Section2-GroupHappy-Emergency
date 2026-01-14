@ -0,0 +1,108 @@
package smilespace.controller;

import smilespace.model.Post;
import smilespace.model.Reply;
import smilespace.model.User;
import smilespace.service.PostService;
import smilespace.service.ReplyService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/forum")
public class ForumController {

    private final PostService postService;
    private final ReplyService replyService;

    public ForumController(PostService postService, ReplyService replyService) {
        this.postService = postService;
        this.replyService = replyService;
    }

    @GetMapping
    public String viewForum(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user"); // use 'user' here
        List<Post> posts = postService.getAllPosts();

        for (Post post : posts) {
            List<Reply> replies = replyService.getRepliesByPostId(post.getPostId());
            post.setReplies(replies);
        }

        model.addAttribute("posts", posts);
        model.addAttribute("user", user); // pass to JSP as 'user'
        return "/peerSupportForumModule/forum";
    }

    @PostMapping("/post")
    public String createPost(@RequestParam String content,
                             @RequestParam(required = false) boolean anonymous,
                             HttpSession session) {
        User user = (User) session.getAttribute("user");
        Post post = new Post();
        post.setUserId(user.getUserId());
        post.setContent(content);
        post.setAnonymous(anonymous);
        postService.createPost(post);
        return "redirect:/forum";
    }

    @PostMapping("/reply")
    public String createReply(@RequestParam int postId,
                              @RequestParam String content,
                              @RequestParam(required = false) boolean anonymous,
                              HttpSession session) {
        User user = (User) session.getAttribute("user");
        Reply reply = new Reply();
        reply.setPostId(postId);
        reply.setUserId(user.getUserId());
        reply.setContent(content);
        reply.setAnonymous(anonymous);
        replyService.createReply(reply);
        return "redirect:/forum";
    }

    @PostMapping("/post/delete")
    public String deletePost(@RequestParam int postId, HttpSession session) {
        User user = (User) session.getAttribute("user");
        postService.deletePost(postId, user.getUserId());
        return "redirect:/forum";
    }

    @PostMapping("/reply/delete")
    public String deleteReply(@RequestParam int replyId, HttpSession session) {
        User user = (User) session.getAttribute("user");
        replyService.deleteReply(replyId, user.getUserId());
        return "redirect:/forum";
    }

    @PostMapping("/post/edit")
    public String editPost(@RequestParam int postId,
                           @RequestParam String content,
                           HttpSession session) {
        User user = (User) session.getAttribute("user");
        Post post = postService.getPostById(postId);
        if(post.getUserId() == user.getUserId()) {
            post.setContent(content);
            postService.updatePost(post);
        }
        return "redirect:/forum";
    }

    @PostMapping("/reply/edit")
    public String editReply(@RequestParam int replyId,
                            @RequestParam String content,
                            HttpSession session) {
        User user = (User) session.getAttribute("user");
        Reply reply = replyService.getReplyById(replyId);
        if(reply != null && reply.getUserId() == user.getUserId()) {
            reply.setContent(content);
            replyService.updateReply(reply);
        }
        return "redirect:/forum";
    }
}

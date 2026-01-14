package smilespace.service;

import smilespace.model.Post;
import java.util.List;

public interface PostService {
    List<Post> getAllPosts();
    void createPost(Post post);
    void updatePost(Post post);
    void deletePost(int postId, int userId); // Only owner can delete
    Post getPostById(int postId);
}

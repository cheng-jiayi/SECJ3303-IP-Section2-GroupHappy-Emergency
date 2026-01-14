package smilespace.dao;

import smilespace.model.Post;
import java.util.List;

public interface PostDAO {
    List<Post> getAllPosts();
    void createPost(Post post);
    void updatePost(Post post);
    void deletePost(int postId);
    Post getPostById(int postId);
}

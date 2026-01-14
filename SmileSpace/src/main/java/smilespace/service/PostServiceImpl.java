package smilespace.service;

import smilespace.dao.PostDAO;
import smilespace.model.Post;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PostServiceImpl implements PostService {

    private final PostDAO postDAO;

    public PostServiceImpl(PostDAO postDAO) {
        this.postDAO = postDAO;
    }

    @Override
    public List<Post> getAllPosts() {
        return postDAO.getAllPosts();
    }

    @Override
    public void createPost(Post post) {
        postDAO.createPost(post);
    }

    @Override
    public void updatePost(Post post) {
        postDAO.updatePost(post);
    }

    @Override
    public void deletePost(int postId, int userId) {
        Post post = postDAO.getPostById(postId);
        if (post.getUserId() == userId) {
            postDAO.deletePost(postId);
        }
    }

    @Override
    public Post getPostById(int postId) {
        return postDAO.getPostById(postId);
    }
}

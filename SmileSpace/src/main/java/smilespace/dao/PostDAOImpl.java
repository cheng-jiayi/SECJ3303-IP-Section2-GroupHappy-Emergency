package smilespace.dao;

import smilespace.model.Post;
import smilespace.model.User;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class PostDAOImpl implements PostDAO {

    private final JdbcTemplate jdbcTemplate;

    public PostDAOImpl(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public List<Post> getAllPosts() {
        String sql = "SELECT p.*, u.full_name, u.username FROM posts p JOIN users u ON p.user_id = u.user_id ORDER BY p.created_at DESC";
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            Post post = new Post();
            post.setPostId(rs.getInt("post_id"));
            post.setUserId(rs.getInt("user_id"));
            post.setContent(rs.getString("content"));
            post.setAnonymous(rs.getBoolean("anonymous"));
            post.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
            if (rs.getTimestamp("updated_at") != null)
                post.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());

            User user = new User();
            user.setUserId(rs.getInt("user_id"));
            user.setFullName(rs.getString("full_name"));
            user.setUsername(rs.getString("username"));
            post.setUser(user);

            return post;
        });
    }

    @Override
    public void createPost(Post post) {
        String sql = "INSERT INTO posts(user_id, content, anonymous) VALUES(?,?,?)";
        jdbcTemplate.update(sql, post.getUserId(), post.getContent(), post.isAnonymous());
    }

    @Override
    public void updatePost(Post post) {
        String sql = "UPDATE posts SET content = ?, updated_at = NOW() WHERE post_id = ?";
        jdbcTemplate.update(sql, post.getContent(), post.getPostId());
    }

    @Override
    public void deletePost(int postId) {
        String sql = "DELETE FROM posts WHERE post_id = ?";
        jdbcTemplate.update(sql, postId);
    }

    @Override
    public Post getPostById(int postId) {
        String sql = "SELECT p.*, u.full_name, u.username FROM posts p JOIN users u ON p.user_id = u.user_id WHERE post_id = ?";
        return jdbcTemplate.queryForObject(sql, new Object[]{postId}, (rs, rowNum) -> {
            Post post = new Post();
            post.setPostId(rs.getInt("post_id"));
            post.setUserId(rs.getInt("user_id"));
            post.setContent(rs.getString("content"));
            post.setAnonymous(rs.getBoolean("anonymous"));
            post.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
            if (rs.getTimestamp("updated_at") != null)
                post.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());

            User user = new User();
            user.setUserId(rs.getInt("user_id"));
            user.setFullName(rs.getString("full_name"));
            user.setUserId(rs.getInt("user_id"));user.setUsername(rs.getString("username"));
            post.setUser(user);

            return post;
        });
    }
}

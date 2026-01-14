package smilespace.dao;

import smilespace.model.Reply;
import smilespace.model.User;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class ReplyDAOImpl implements ReplyDAO {

    private final JdbcTemplate jdbcTemplate;

    public ReplyDAOImpl(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public List<Reply> getRepliesByPostId(int postId) {
        String sql = "SELECT r.*, u.full_name, u.username " +
                     "FROM replies r " +
                     "JOIN users u ON r.user_id = u.user_id " +
                     "WHERE r.post_id = ? " +
                     "ORDER BY r.created_at ASC";
        return jdbcTemplate.query(sql, new Object[]{postId}, (rs, rowNum) -> {
            Reply reply = new Reply();
            reply.setReplyId(rs.getInt("reply_id"));
            reply.setPostId(rs.getInt("post_id"));
            reply.setUserId(rs.getInt("user_id"));
            reply.setContent(rs.getString("content"));
            reply.setAnonymous(rs.getBoolean("anonymous"));
            reply.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
            if (rs.getTimestamp("updated_at") != null)
                reply.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());

            User user = new User();
            user.setUserId(rs.getInt("user_id"));
            user.setFullName(rs.getString("full_name"));
            user.setUsername(rs.getString("username"));
            reply.setUser(user);

            return reply;
        });
    }

    @Override
    public void createReply(Reply reply) {
        String sql = "INSERT INTO replies(post_id, user_id, content, anonymous) VALUES(?,?,?,?)";
        jdbcTemplate.update(sql, reply.getPostId(), reply.getUserId(), reply.getContent(), reply.isAnonymous());
    }

    @Override
    public void updateReply(Reply reply) {
        String sql = "UPDATE replies SET content = ?, updated_at = NOW() WHERE reply_id = ?";
        jdbcTemplate.update(sql, reply.getContent(), reply.getReplyId());
    }

    @Override
    public void deleteReply(int replyId) {
        String sql = "DELETE FROM replies WHERE reply_id = ?";
        jdbcTemplate.update(sql, replyId);
    }

    @Override
    public Reply getReplyById(int replyId) {
        String sql = "SELECT r.*, u.full_name, u.username " +
                     "FROM replies r " +
                     "JOIN users u ON r.user_id = u.user_id " +
                     "WHERE r.reply_id = ?";
        return jdbcTemplate.queryForObject(sql, new Object[]{replyId}, (rs, rowNum) -> {
            Reply reply = new Reply();
            reply.setReplyId(rs.getInt("reply_id"));
            reply.setPostId(rs.getInt("post_id"));
            reply.setUserId(rs.getInt("user_id"));
            reply.setContent(rs.getString("content"));
            reply.setAnonymous(rs.getBoolean("anonymous"));
            reply.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
            if (rs.getTimestamp("updated_at") != null)
                reply.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());

            User user = new User();
            user.setUserId(rs.getInt("user_id"));
            user.setFullName(rs.getString("full_name"));
            user.setUsername(rs.getString("username"));
            reply.setUser(user);

            return reply;
        });
    }
}

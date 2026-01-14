package smilespace.test;
import org.mindrot.jbcrypt.BCrypt;

public class GenerateBCryptHashes {
    public static void main(String[] args) {
        String password = "password123";
        
        System.out.println("Generating BCrypt hashes for: " + password);
        System.out.println("=" .repeat(50));
        
        // Generate multiple hashes (BCrypt uses different salt each time)
        for (int i = 1; i <= 3; i++) {
            String hash = BCrypt.hashpw(password, BCrypt.gensalt());
            System.out.println("Hash " + i + ": " + hash);
            System.out.println("Length: " + hash.length());
            
            // Verify
            boolean valid = BCrypt.checkpw(password, hash);
            System.out.println("Valid: " + valid);
            System.out.println();
        }
    }
}
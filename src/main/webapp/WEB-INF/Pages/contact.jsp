<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact - TuneHub</title>
    <style>
        :root{--bg:#000;--sf:#121212;--sf2:#1a1a1a;--t:#fff;--t2:#b3b3b3;--g:#1db954;--p:#8b5cf6;--b:rgba(255,255,255,0.08);--rd:16px}
        *{box-sizing:border-box;margin:0;padding:0}body{font-family:'Inter',system-ui,sans-serif;background:var(--bg);color:var(--t);line-height:1.6;min-height:100vh}
        header{background:rgba(0,0,0,0.95);backdrop-filter:blur(20px);padding:1rem 3rem;position:sticky;top:0;z-index:1000;border-bottom:1px solid var(--b)}
        .nav{max-width:1200px;margin:0 auto;display:flex;justify-content:space-between;align-items:center}
        .logo{font-size:1.8rem;font-weight:800;background:linear-gradient(135deg,var(--g),var(--p));-webkit-background-clip:text;color:transparent}
        nav{display:flex;gap:2rem}nav a{color:var(--t2);text-decoration:none;font-weight:600;transition:0.2s}nav a:hover{color:var(--t)}
        .hero{max-width:800px;margin:0 auto;padding:5rem 2rem 3rem;text-align:center}
        .hero h1{font-size:3rem;font-weight:900;margin-bottom:1rem;background:linear-gradient(135deg,#fff,#a5b4fc);-webkit-background-clip:text;color:transparent}
        .hero p{color:var(--t2);font-size:1.2rem}
        .content{max-width:800px;margin:0 auto;padding:0 2rem 4rem}
        .card{background:var(--sf);border:1px solid var(--b);border-radius:var(--rd);padding:2rem;margin-bottom:2rem}
        .card h3{color:var(--g);margin-bottom:1rem}
        .contact-method{display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--sf2);border-radius:8px;margin-bottom:0.8rem}
        .contact-method span{font-size:1.5rem}
        .contact-method a{color:var(--t);text-decoration:none;font-weight:500}
        .contact-method a:hover{color:var(--g)}
        .form-group{margin-bottom:1rem}
        .form-group label{display:block;font-size:0.9rem;color:var(--t2);margin-bottom:0.4rem}
        .form-group input,.form-group textarea{width:100%;padding:0.8rem;background:var(--sf2);border:1px solid var(--b);border-radius:8px;color:var(--t);font-size:1rem}
        .form-group input:focus,.form-group textarea:focus{outline:none;border-color:var(--g)}
        .btn{padding:0.8rem 2rem;background:var(--g);color:#000;border:none;border-radius:500px;font-weight:700;cursor:pointer;transition:0.2s}
        .btn:hover{background:var(--g);transform:translateY(-2px)}
        footer{background:var(--sf);padding:3rem 2rem;text-align:center;color:var(--t2);border-top:1px solid var(--b)}
        footer a{color:var(--t2);text-decoration:none;margin:0 0.5rem}footer a:hover{color:var(--t)}
        @media(max-width:768px){header{padding:1rem}.nav{flex-direction:column;gap:1rem}.hero{padding:3rem 1rem}.hero h1{font-size:2.2rem}}
    </style>
</head>
<body>
    <header>
        <div class="nav">
            <div class="logo">🎵 TuneHub</div>
            <nav>
                <a href="${pageContext.request.contextPath}/">Home</a>
                <a href="${pageContext.request.contextPath}/about">About</a>
            </nav>
        </div>
    </header>

    <section class="hero">
        <h1>Get in Touch</h1>
        <p>Have questions, feedback, or need support? We're here to help.</p>
    </section>

    <div class="content">
        <div class="card">
            <h3>📬 Contact Methods</h3>
            <div class="contact-method">
                <span>✉️</span>
                <div>
                    <strong>Email</strong><br>
                    <a href="mailto:support@tunehub.com">support@tunehub.com</a>
                </div>
            </div>
            <div class="contact-method">
                <span>📍</span>
                <div>
                    <strong>Location</strong><br>
                    <span style="color:var(--t2)">TuneHub HQ, Digital Campus</span>
                </div>
            </div>
            <div class="contact-method">
                <span>⏱️</span>
                <div>
                    <strong>Response Time</strong><br>
                    <span style="color:var(--t2)">Within 24 hours</span>
                </div>
            </div>
        </div>

        <div class="card">
            <h3>📝 Send a Message</h3>
            <form>
                <div class="form-group">
                    <label for="name">Your Name</label>
                    <input type="text" id="name" name="name" required>
                </div>
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <div class="form-group">
                    <label for="message">Message</label>
                    <textarea id="message" name="message" rows="5" required></textarea>
                </div>
                <button type="submit" class="btn">Send Message</button>
            </form>
        </div>

        <div class="card">
            <h3>❓ Frequently Asked Questions</h3>
            <details style="margin-bottom:0.8rem;padding:0.8rem;background:var(--sf2);border-radius:8px">
                <summary style="cursor:pointer;font-weight:600">How do I create a playlist?</summary>
                <p style="color:var(--t2);margin-top:0.5rem">Go to your dashboard, click "Create Playlist", enter a name, and start adding songs!</p>
            </details>
            <details style="margin-bottom:0.8rem;padding:0.8rem;background:var(--sf2);border-radius:8px">
                <summary style="cursor:pointer;font-weight:600">Can I make my playlist public?</summary>
                <p style="color:var(--t2);margin-top:0.5rem">Yes! Toggle the "Public" checkbox when creating or editing a playlist.</p>
            </details>
            <details style="padding:0.8rem;background:var(--sf2);border-radius:8px">
                <summary style="cursor:pointer;font-weight:600">How do I contact support?</summary>
                <p style="color:var(--t2);margin-top:0.5rem">Use the form above or email us directly at support@tunehub.com</p>
            </details>
        </div>
    </div>

    <footer>
        <p>&copy; 2026 TuneHub. Built for music lovers. All rights reserved.</p>
        <p style="margin-top:0.5rem">
            <a href="${pageContext.request.contextPath}/">Home</a> | 
            <a href="${pageContext.request.contextPath}/about">About</a>
        </p>
    </footer>
</body>
</html>
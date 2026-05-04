<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Contact - TuneHub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
</head>
<body>
    <header>
        <div class="nav-c">
            <div class="logo">🎵 TuneHub</div>
            <nav>
                <a href="${pageContext.request.contextPath}/">Home</a>
                <a href="${pageContext.request.contextPath}/login">Login</a>
            </nav>
        </div>
    </header>
    <div class="container">
        <div class="auth-f" style="max-width:500px">
            <h2 class="tc">Contact Us 📬</h2>
            <% if ("success".equals(request.getParameter("status"))) { %>
                <div class="alert alert-o">Message sent successfully!</div>
            <% } %>
            <form action="${pageContext.request.contextPath}/contact" method="post">
                <div class="fg">
                    <label>Name *</label>
                    <input type="text" name="name" required>
                </div>
                <div class="fg">
                    <label>Email *</label>
                    <input type="email" name="email" required>
                </div>
                <div class="fg">
                    <label>Message *</label>
                    <textarea name="message" rows="5" required style="width:100%;padding:.75rem;border:2px solid var(--lav-l);border-radius:8px"></textarea>
                </div>
                <button type="submit" class="btn">Send Message</button>
            </form>
            <p class="tc mt2"><a href="${pageContext.request.contextPath}/" style="color:var(--lav)">← Home</a></p>
        </div>
    </div>
    <footer><p>&copy; 2026 TuneHub</p></footer>
</body>
</html>
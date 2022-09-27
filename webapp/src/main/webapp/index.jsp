<form action="action_page.php">
  <div class="container">
    <h2>Welcome to Vincent Lee Hello World Newsletter,deployed using jenkins</h2>
    <p>Enter Name & Email To subscribe to newsletter</p>
  </div>

  <div class="container" style="background-color:white">
    <input type="text" placeholder="Name" name="name" required>
    <input type="text" placeholder="Email address" name="mail" required>
    <label>
      <input type="checkbox" checked="checked" name="subscribe"> Daily Newsletter
    </label>
  </div>

  <div class="container">
    <input type="submit" value="Subscribe">
  </div>
</form>